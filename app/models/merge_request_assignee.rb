# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class MergeRequestAssignee < ApplicationRecord
  belongs_to :merge_request, touch: true
  belongs_to :assignee, class_name: "User", foreign_key: :user_id, inverse_of: :merge_request_assignees
  belongs_to :project, optional: true

  validates :assignee, uniqueness: { scope: :merge_request_id }

  scope :in_projects, ->(project_ids) { joins(:merge_request).where(merge_requests: { target_project_id: project_ids }) }
  scope :for_assignee, ->(user) { where(assignee: user) }

end