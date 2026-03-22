# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Branches
  class ValidateNewService < BaseService
    def initialize(project)
      @project = project
    end

    def execute(branch_name, force: false)
      return error('Branch name is invalid') unless valid_name?(branch_name)

      if branch_exist?(branch_name) && !force
        return error('Branch already exists')
      end

      success
    rescue Gitlab::Git::PreReceiveError => ex
      error(ex.message)
    end

    private

    def valid_name?(branch_name)
      Gitlab::GitRefValidator.validate(branch_name)
    end

    def branch_exist?(branch_name)
      project.repository.branch_exists?(branch_name)
    end
  end
end

Branches::ValidateNewService.prepend_mod

