# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module DependencyLinker
    class CartfileLinker < MethodLinker
      self.file_type = :cartfile

      private

      def link_dependencies
        link_method_call('github', REPO_REGEX, &method(:github_url))
        link_method_call(%w[github git binary], URL_REGEX, &:itself)
      end
    end
  end
end
