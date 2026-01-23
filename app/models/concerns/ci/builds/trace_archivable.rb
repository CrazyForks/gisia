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
    module TraceArchivable
      extend ActiveSupport::Concern
      include Gitlab::ExclusiveLeaseHelpers

      EXCLUSIVE_LOCK_KEY = 'archive_trace_service:batch_execute:lock'
      LOCK_TIMEOUT = 56.minutes
      LOOP_TIMEOUT = 55.minutes
      BATCH_SIZE = 100
      LOOP_LIMIT = 2000

      class_methods do
        include Gitlab::ExclusiveLeaseHelpers

        def batch_archive_traces!
          start_time = Time.current
          in_lock(EXCLUSIVE_LOCK_KEY, ttl: LOCK_TIMEOUT, retries: 1) do
            with_stale_live_trace.find_each(batch_size: BATCH_SIZE).with_index do |build, index|
              break if Time.current - start_time > LOOP_TIMEOUT

              if index > LOOP_LIMIT
                Sidekiq.logger.warn(class: self.class, message: 'Loop limit reached.', job_id: id)
                break
              end

              begin
                build.archive_trace!
              rescue StandardError
                next
              end
            end
          end
        end
      end

      def archive_trace!
        unless trace.archival_attempts_available?
          Sidekiq.logger.warn(class: self.class, message: 'The job is out of archival attempts.', job_id: id)

          trace.attempt_archive_cleanup!
          return
        end

        unless trace.can_attempt_archival_now?
          Sidekiq.logger.warn(class: self.class, message: 'The job can not be archived right now.', job_id: id)
          return
        end

        trace.archive!
        remove_pending_state!
      rescue ::Gitlab::Ci::Trace::AlreadyArchivedError
      # Already archived, safely ignore
      rescue StandardError
        trace.increment_archival_attempts!
        raise
      end
    end
  end
end
