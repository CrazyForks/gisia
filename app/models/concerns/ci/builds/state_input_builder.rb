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
    class StateInputBuilder
      attr_reader :state, :trace_checksum, :trace_bytesize, :failure_reason, :exit_code

      def self.from(params)
        new(
          state: params[:state],
          trace_checksum: params.dig(:output, :checksum) || params[:checksum],
          trace_bytesize: params.dig(:output, :bytesize),
          failure_reason: params[:failure_reason],
          exit_code: params[:exit_code]
        )
      end

      def initialize(state:, trace_checksum:, trace_bytesize:, failure_reason:, exit_code: nil)
        @state = state.to_s
        @trace_checksum = trace_checksum
        @trace_bytesize = trace_bytesize
        @failure_reason = format_failure(failure_reason)
        @exit_code = exit_code
      end

      private

      def format_failure(reason)
        return unless reason

        Ci::BuildPendingState.failure_reasons.fetch(reason.to_s, 'unknown_failure')
      end
    end
  end
end

