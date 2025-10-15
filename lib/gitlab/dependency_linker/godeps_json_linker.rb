# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module DependencyLinker
    class GodepsJsonLinker < JsonLinker
      NESTED_REPO_REGEX = %r{([^/]+/)+[^/]+?}

      self.file_type = :godeps_json

      private

      def link_dependencies
        link_json('ImportPath') do |path|
          case path
          when %r{\A(?<repo>github\.com/#{REPO_REGEX})/(?<path>.+)\z}o
            "https://#{$~[:repo]}/tree/master/#{$~[:path]}"
          when %r{\A(?<repo>gitlab\.com/#{NESTED_REPO_REGEX})\.git/(?<path>.+)\z}o,
            %r{\A(?<repo>gitlab\.com/#{REPO_REGEX})/(?<path>.+)\z}o

            "https://#{$~[:repo]}/-/tree/master/#{$~[:path]}"
          when /\Agolang\.org/
            "https://godoc.org/#{path}"
          else
            "https://#{path}"
          end
        end
      end
    end
  end
end
