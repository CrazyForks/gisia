# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class WorkItemAssignee < ApplicationRecord
  belongs_to :work_item
  belongs_to :assignee, class_name: 'User'

  validates :work_item_id, uniqueness: { scope: :assignee_id }
end