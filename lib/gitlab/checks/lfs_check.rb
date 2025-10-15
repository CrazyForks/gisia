# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Checks
    class LfsCheck < BaseBulkChecker
      LOG_MESSAGE = 'Scanning repository for blobs stored in LFS and verifying their files have been uploaded to GitLab...'
      ERROR_MESSAGE = 'LFS objects are missing. Ensure LFS is properly set up or try a manual "git lfs push --all".'

      def validate!
        return unless project.lfs_enabled?

        logger.log_timed(LOG_MESSAGE) do
          newrevs = changes.map { |change| change[:newrev] }
          lfs_check = Checks::LfsIntegrity.new(project, newrevs, logger.time_left)

          if lfs_check.objects_missing?
            Gitlab::Metrics::Lfs.check_objects_error_rate.increment(error: true, labels: {})
            raise GitAccess::ForbiddenError, ERROR_MESSAGE
          else
            Gitlab::Metrics::Lfs.check_objects_error_rate.increment(error: false, labels: {})
          end
        end
      end
    end
  end
end
