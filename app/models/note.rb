# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Note < ApplicationRecord
  include AfterCommitQueue
  include EachBatch
  include Notes::Discussable

  self.primary_key = :id

  # Attribute used to determine whether keep_around_commits will be skipped for diff notes.
  attr_accessor :skip_keep_around_commits

  belongs_to :namespace
  belongs_to :noteable, polymorphic: true
  belongs_to :author, class_name: 'User'
  belongs_to :updated_by, class_name: 'User', optional: true
  belongs_to :resolved_by, class_name: 'User', optional: true

  validates :id, uniqueness: true
  validates :author, presence: true
  validates :noteable_type, presence: true
  validates :noteable_id, presence: true

  before_validation :convert_note_to_html

  scope :new_diff_notes, -> { where(type: 'DiffNote') }
  scope :system, -> { where(system: true) }
  # Todo,
  scope :resolvable, -> { where(system: false) }
  scope :resolved, -> { resolvable.where.not(resolved_at: nil) }
  scope :unresolved, -> { resolvable.where(resolved_at: nil) }
  scope :internal, -> { where(internal: true) }
  scope :inc_relations_for_view, ->(_noteable = nil) do
    relations = %i[
      namespace author updated_by resolved_by
    ]

    includes(relations)
  end
  scope :fresh, -> { order(:created_at, :id) }

  def self.partition_model_for(noteable_type)
    case noteable_type
    when 'Issue', 'WorkItem'
      IssueNote
    when 'Epic'
      EpicNote
    when 'MergeRequest'
      MergeRequestNote
    else
      self
    end
  end

  def clear_memoized_values
  end

  def resolvable?
    return false unless noteable.respond_to?(:discussions_resolvable?)
    return false if system?

    noteable.discussions_resolvable?
  end

  def resolved?
    return false unless resolvable?

    resolved_at.present?
  end

  def resolve!(current_user)
    return unless resolvable?
    return if resolved?

    self.resolved_at = Time.current
    self.resolved_by = current_user
    save!
  end

  def unresolve!
    return unless resolvable?
    return unless resolved?

    self.resolved_at = nil
    self.resolved_by = nil
    save!
  end

  def diff_note?
    false
  end

  def edited?
    last_edited_at.present? && last_edited_at != created_at
  end

  def last_edited_by
    updated_by if edited?
  end

  def project
    namespace&.project
  end

  def for_design?
    false
  end

  def for_commit?
    false
  end

  private

  def convert_note_to_html
    return unless note_changed? && note.present?

    self.note_html = Banzai::Renderer.render(note)
  end
end
