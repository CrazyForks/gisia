# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Ci
  module StuckBuilds
    class DropScheduledService
      include DropHelpers

      BUILD_SCHEDULED_OUTDATED_TIMEOUT = 1.hour

      def execute
        Gitlab::AppLogger.info "#{self.class}: Cleaning scheduled, timed-out builds"

        drop(scheduled_timed_out_builds, failure_reason: :stale_schedule)
      end

      private

      def scheduled_timed_out_builds
        Ci::Build.scheduled.scheduled_at_before(BUILD_SCHEDULED_OUTDATED_TIMEOUT.ago)
      end
    end
  end
end

