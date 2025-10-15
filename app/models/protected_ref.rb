# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class ProtectedRef < ApplicationRecord
  include Gitlab::Utils::StrongMemoize
  include Accessible
  include ProtectedRefs::Protectable

  belongs_to :namespace
  belongs_to :project_namespace,
    class_name: 'Namespaces::ProjectNamespace',
    foreign_key: 'namespace_id'

  has_one :project, through: :project_namespace, touch: true

  validates :type, presence: true
  validates :access_level,
    inclusion: { in: %w[developer maintainer owner], message: 'must be developer, maintainer, or owner' }

  def branch?
    type == 'ProtectedBranch'
  end

  def tag?
    type == 'ProtectedTag'
  end

  def self.protected_ref_accessible_to?(ref, user, project:, action:, protected_refs: nil)
    protected_refs = protected_refs.with_access_levels(action) if action && ProtectedRef.respond_to?(action)
    protected_refs = protected_refs.joins(:project).where(projects: { id: project.id })
    max_access = user.max_access(project)

    protected_refs.allowed? max_access, ref
  end
end
