# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Issue < WorkItem
  validates :namespace, presence: true

  has_many :notes, -> { where(noteable_type: 'Issue') }, class_name: 'IssueNote', foreign_key: :noteable_id, dependent: :destroy

  scope :in_project, ->(project) { joins(:namespace).where(namespaces: { project: project }) }
  scope :by_iid, ->(iid) { where(iid: iid) }

  def self.reference_prefix
    '#'
  end

  def self.internal_id_scope_usage
    :issues
  end

end
