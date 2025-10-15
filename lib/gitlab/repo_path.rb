# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Gitlab
  module RepoPath
    NotFoundError = Class.new(StandardError)

    def self.parse(path)
      repo_path = path.delete_prefix('/').delete_suffix('.git')

      Gitlab::GlRepository.types.each do |_name, type|
        next unless type.valid?(repo_path)

        full_path = repo_path.chomp(type.path_suffix)
        container, project = find_container(type, full_path)
        next unless container

        redirected_path = repo_path if redirected?(container, repo_path)
        return [container, project, type, redirected_path]
      end

      [nil, nil, Gitlab::GlRepository.default_type, nil]
    end

    def self.find_container(type, full_path)
      return [nil, nil] if full_path.blank?

      project = find_project(full_path)

      [project, project]
    end

    def self.find_project(project_path)
      Project.find_by_full_path(project_path, follow_redirects: true)
    end

    def self.redirected?(container, container_path)
      container && container.full_path.casecmp(container_path) != 0
    end

    def self.find_design_management_repository(full_path)
      find_project(full_path)&.design_management_repository
    end
  end
end

