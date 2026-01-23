# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class GroupMember < Member
  include FromUnion
  include CreatedAtFilterable

  belongs_to :namespace, class_name: 'Namespaces::GroupNamespace', foreign_key: 'namespace_id'
  has_one :group, through: :namespace

  scope :of_groups, ->(groups) { where(source_id: groups) }
  scope :count_users_by_namespace_id, -> { group(:namespace_id).count }
end
