# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Checks
    class BaseBulkChecker < BaseChecker
      attr_reader :changes_access

      delegate(*ChangesAccess::ATTRIBUTES, to: :changes_access)

      def initialize(changes_access)
        @changes_access = changes_access
      end

      def validate!
        raise NotImplementedError
      end
    end
  end
end
