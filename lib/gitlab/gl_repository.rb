# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Gitlab
  class GlRepository
    include Singleton

    PROJECT = Gitlab::Repositories::ProjectRepository.instance

    TYPES = {
      PROJECT.type_id => PROJECT,
    }.freeze

    def self.types
      instance.types
    end

    def self.parse(gl_repository)
      identifier = ::Gitlab::Repositories::Identifier.parse(gl_repository)

      repo_type = identifier.repo_type
      container = identifier.container

      [container, repo_type.project_for(container), repo_type]
    end

    def self.default_type
      PROJECT
    end

    def types
      TYPES
    end

    private_class_method :instance
  end
end
