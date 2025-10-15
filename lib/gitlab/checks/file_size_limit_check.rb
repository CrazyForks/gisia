# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Checks
    class FileSizeLimitCheck < BaseBulkChecker
      include ActionView::Helpers::NumberHelper

      def validate!
        nil
      end

      private

      # rubocop:disable Gitlab/NoCodeCoverageComment -- This is fully overriden in EE,Lint/MissingCopEnableDirective
      # :nocov:
      def file_size_limit
        nil
      end
      # :nocov:
      # rubocop:enable Gitlab/NoCodeCoverageComment
    end
  end
end

Gitlab::Checks::FileSizeLimitCheck.prepend_mod
