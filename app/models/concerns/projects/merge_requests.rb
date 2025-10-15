# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Projects
  module MergeRequests
    extend ActiveSupport::Concern

    included do
      has_many :merge_requests, foreign_key: 'target_project_id', inverse_of: :target_project, dependent: :destroy
      has_many :source_of_merge_requests, foreign_key: 'source_project_id', class_name: 'MergeRequest'
    end

    # Returns all origin and fork merge requests from `@project` satisfying passed arguments.
    def merge_requests_for(source_branch, mr_states: [:opened])
      source_of_merge_requests
        .with_state(mr_states)
        .where(source_branch: source_branch)
        .preload(:source_project) # we don't need #includes since we're just preloading for the #select
        .select(&:source_project)
    end

    def merge_requests_allowing_push_to_user(_user)
      MergeRequest.none
    end
  end
end
