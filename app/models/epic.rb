# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Epic < WorkItem
  has_many :notes, -> { where(noteable_type: 'Epic') }, class_name: 'EpicNote', foreign_key: :noteable_id, dependent: :destroy

  validates :namespace, presence: true

  scope :in_namespace, ->(namespace) { where(namespace: namespace) }
  scope :by_iid, ->(iid) { where(iid: iid) }

  def self.reference_prefix
    '&'
  end

  def to_reference(from = nil, full: false)
    reference = "#{self.class.reference_prefix}#{iid}"
    "#{namespace.to_reference_base(from, full: full)}#{reference}"
  end

  def self.internal_id_scope_usage
    :epics
  end
end
