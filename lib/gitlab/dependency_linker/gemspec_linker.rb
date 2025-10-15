# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module DependencyLinker
    class GemspecLinker < MethodLinker
      self.file_type = :gemspec

      private

      def link_dependencies
        link_method_call('homepage', URL_REGEX, &:itself)
        link_method_call('license', &method(:license_url))

        link_method_call(%w[add_dependency add_runtime_dependency add_development_dependency]) do |name|
          "https://rubygems.org/gems/#{name}"
        end
      end
    end
  end
end
