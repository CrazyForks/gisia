# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module DependencyLinker
    class Package
      attr_reader :name, :git_ref, :github_ref

      def initialize(name, git_ref, github_ref)
        @name = name
        @git_ref = git_ref
        @github_ref = github_ref
      end

      def external_ref
        @git_ref || @github_ref
      end
    end
  end
end
