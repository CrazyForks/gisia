# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class ProtectedTag < ProtectedRef
  scope :with_create, -> { where(allow_push: true) }

  def self.protected?(project, name)
    return false if name.blank?
    return true if project.empty_repo?

    matches?(name, protected_refs: project.protected_tags)
  end

  def self.with_access_levels(level)
    return none if level != :create

    with_create
  end
end
