# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class ProjectMember < Member
  belongs_to :user
  belongs_to :namespace, class_name: 'Namespaces::ProjectNamespace', foreign_key: 'namespace_id'
  has_one :project, through: :namespace

  scope :with_project, ->(project) { with_namespace project.namespace }
  scope :with_namespace, ->(namespace) { where(namespace_id: namespace.id) }
  scope :with_roles, ->(roles) { where(access_level: roles) }

  class << self
    def max_access
      maximum(:access_level)
    end
  end

end

ProjectMember.prepend_mod_with('ProjectMember')
