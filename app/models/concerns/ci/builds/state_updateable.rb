# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module Builds
    module StateUpdateable
      extend ActiveSupport::Concern
      extend MethodOverrideGuard

      StateUpdateResult = Struct.new(:status, :backoff, keyword_init: true)
      InvalidTraceError = Class.new(StandardError)
      ACCEPT_TIMEOUT = 5.minutes.freeze

      def update_state!(input)
        @state_input = input
        return update_build_state! if !acceptable?

        ensure_pending_state!
        process_build_state!
      end

      private

      def state_input
        @state_input
      end

      def process_build_state!
        if live_chunks_pending?
          if pending_state_outdated?
            update_build_state!
          else
            accept_build_state!
          end
        else
          validate_build_trace!
          update_build_state!
        end
      end

      def accept_build_state!
        trace_chunks.live.find_each do |chunk|
          chunk.schedule_to_persist!
        end

        metrics.increment_trace_operation(operation: :accepted)

        ::Gitlab::Ci::Runner::Backoff.new(scoped_pending_state.created_at).then do |backoff|
          StateUpdateResult.new(status: 202, backoff: backoff.to_seconds)
        end
      end

      def live_chunks_pending?
        trace_chunks.live.any?
      end

      def pending_state_outdated?
        pending_state_duration > ACCEPT_TIMEOUT
      end

      def pending_state_duration
        Time.current - scoped_pending_state.created_at
      end

      def ensure_pending_state!
        scoped_pending_state.created_at
      end

      def scoped_pending_state
        strong_memoize(:scoped_pending_state) { ensure_pending_state }
      end

      def ensure_pending_state
        Ci::BuildPendingState.safe_find_or_create_by(
          build_id: id,
          state: state_input.state,
          trace_checksum: state_input.trace_checksum,
          trace_bytesize: state_input.trace_bytesize,
          failure_reason: state_input.failure_reason
        ) || scoped_pending_state
      end

      def acceptable?
        !build_running? && has_checksum? && chunks_migration_enabled?
      end

      def has_checksum?
        state_input.trace_checksum.present?
      end

      def build_running?
        state_input.state == 'running'
      end

      def chunks_migration_enabled?
        # Todo,
        false
      end

      def update_build_state!
        case state_input.state
        when 'running'
          touch if needs_touch?

          StateUpdateResult.new(status: 200)
        when 'success'
          succeed!

          StateUpdateResult.new(status: 200)
        when 'failed'
          drop_with_exit_code!(state_input.failure_reason, state_input.exit_code)

          StateUpdateResult.new(status: 200)
        else
          StateUpdateResult.new(status: 400)
        end
      end

      def validate_build_trace!
        return unless has_chunks?

        ::Gitlab::Ci::Trace::Checksum.new(build).then do |checksum|
          unless checksum.valid?
            metrics.increment_trace_operation(operation: :invalid)
            metrics.increment_error_counter(error_reason: :chunks_invalid_checksum)

            if checksum.corrupted?
              metrics.increment_trace_operation(operation: :corrupted)
              metrics.increment_error_counter(error_reason: :chunks_invalid_size)
            end

            next unless log_invalid_chunks?

            ::Gitlab::ErrorTracking.log_exception(InvalidTraceError.new,
              project_path: project.full_path,
              build_id: id,
              state_crc32: checksum.state_crc32,
              chunks_crc32: checksum.chunks_crc32,
              chunks_count: checksum.chunks_count,
              chunks_corrupted: checksum.corrupted?)
          end
        end
      end

      def has_chunks?
        trace_chunks.any?
      end
    end
  end
end

