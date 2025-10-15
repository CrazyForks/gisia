# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module DependencyLinker
    class ComposerJsonLinker < PackageJsonLinker
      self.file_type = :composer_json

      private

      def link_packages
        link_packages_at_key("require")
        link_packages_at_key("require-dev")
      end

      def package_url(name)
        "https://packagist.org/packages/#{name}" if /\A#{REPO_REGEX}\z/o.match?(name)
      end
    end
  end
end
