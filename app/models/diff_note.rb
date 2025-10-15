# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class DiffNote < Note
  include NoteOnDiff
  include DiffPositionableNote
  include Gitlab::Utils::StrongMemoize
  include Notes::HasMergeRequest
  include Notes::HasNoteDiffFile

  validates :original_position, presence: true
  validates :position, presence: true
  validates :line_code, presence: true

  validates :noteable_type, inclusion: { in: ->(_note) { noteable_types } }
  validate :positions_complete
  validate :verify_supported, unless: :importing?

  before_validation :set_line_code, if: :on_text?, unless: :importing?
  after_save :keep_around_commits, unless: -> { importing? || skip_keep_around_commits }

  def self.noteable_types
    %w[MergeRequest]
  end

  private

  def set_line_code
    self.line_code = self.line_code.presence || self.position.line_code(repository)
  end

  def importing?
    false
  end

  def verify_supported
    return if supported?

    errors.add(:noteable, "doesn't support new-style diff notes")
  end

  def positions_complete
    return if self.original_position.complete? && self.position.complete?

    errors.add(:position, 'is incomplete')
  end
end
