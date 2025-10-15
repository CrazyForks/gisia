# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class MergeRequestReviewer < ApplicationRecord
  include MergeRequestReviewerState

  belongs_to :merge_request
  belongs_to :reviewer, class_name: 'User', foreign_key: :user_id, inverse_of: :merge_request_reviewers
  belongs_to :project

  before_validation :set_project

  def cache_key
    [model_name.cache_key, id, state, reviewer.cache_key]
  end

  private

  def set_project
    self.project_id ||= merge_request&.target_project_id
  end
end
