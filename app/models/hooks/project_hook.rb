# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class ProjectHook < WebHook
  self.allow_legacy_sti_class = true

  has_one :project, through: :namespace

  scope :for_projects, ->(project) { where(namespace_id: project.namespace_id) }
  scope :branch_push, -> { where(push_events: true) }
  scope :tag_push, -> { where(tag_push_events: true) }
end

