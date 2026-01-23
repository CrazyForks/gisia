# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class WorkItem < ApplicationRecord
  include AtomicInternalId
  include Noteable
  include Issuable
  include Referable
  include WorkItems::HasState
  include WorkItems::HasWorkflows
  include WorkItems::HasLabels
  include WorkItems::HasParent

  belongs_to :author, class_name: 'User'
  belongs_to :updated_by, class_name: 'User', optional: true
  belongs_to :closed_by, class_name: 'User', optional: true
  belongs_to :namespace
  has_one :project, through: :namespace
  has_many :work_item_assignees, dependent: :destroy
  has_many :assignees, class_name: 'User', through: :work_item_assignees
  has_many :label_links, as: :labelable, dependent: :destroy
  has_many :labels, through: :label_links

  validates :title, presence: true
  validates :confidential, inclusion: { in: [true, false] }
  validates :type, presence: true, inclusion: { in: %w[Issue Epic] }

  before_validation :convert_description_to_html

  has_internal_id :iid, scope: :namespace

  scope :confidential, -> { where(confidential: true) }
  scope :public_only, -> { where(confidential: false) }
  scope :with_state, ->(name) { where(state_id: name) }
  scope :closed, -> { where(state_id: :closed) }
  scope :open, -> { where(state_id: :opened) }
  scope :with_label_ids, ->(label_ids) do
    if label_ids.blank?
      all
    else
      label_link_ids = LabelLink.joins(:label)
                                .where(labels: { id: label_ids }, labelable_type: 'WorkItem')
                                .group('labelable_id')
                                .having('COUNT(*) = ?', label_ids.size)
                                .pluck('labelable_id')
      where(id: label_link_ids)
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title description state_id author_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[author updated_by closed_by namespace labels]
  end

  def clear_closure_reason_references; end

  def assignee_ids
    assignees.pluck(:id)
  end

  def self.reference_prefix
    '#' # Default for issues
  end

  # `from` argument can be a Namespace or Project.
  def to_reference(from = nil, full: false, absolute_path: false)
    reference = "#{self.class.reference_prefix}#{iid}"

    "#{namespace.to_reference_base(from, full: full, absolute_path: absolute_path)}#{reference}"
  end

  # Override from Noteable concern
  def discussions_resolvable?
    true
  end

  def has_widget?(widget)
    case widget
    when :notes
      true
    else
      false
    end
  end

  def epic?
    type == 'Epic'
  end

  alias_method :epic_work_item?, :epic?

  def issue?
    type == 'Issue'
  end

  def hidden?
    author&.banned?
  end

  private

  def convert_description_to_html
    return unless description_changed? && description.present?

    self.description_html = Banzai::Renderer.render(description)
  end
end
