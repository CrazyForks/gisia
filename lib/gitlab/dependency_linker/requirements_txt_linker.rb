# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module DependencyLinker
    class RequirementsTxtLinker < BaseLinker
      self.file_type = :requirements_txt

      private

      def link_dependencies
        link_regex(/^(?<name>(?![a-z+]+:)[^#.-][^ ><=~!;\[]+)/) do |name|
          "https://pypi.org/project/#{name}/"
        end

        link_regex(%r{^(?<name>https?://[^ ]+)}, &:itself)
      end
    end
  end
end
