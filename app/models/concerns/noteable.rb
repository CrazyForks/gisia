# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Noteable
  extend ActiveSupport::Concern

  MAX_NOTES_LIMIT = 5_000

  class_methods do
    def replyable_types
      %w[Issue MergeRequest Epic]
    end

    def resolvable_types
      %w[Issue MergeRequest Epic]
    end

    def email_creatable_types
      %w[Issue MergeRequest Epic]
    end
  end

  def discussions_resolvable?
    false
  end

  def discussion_locked?
    return false unless respond_to?(:discussion_locked)

    discussion_locked
  end

  def lock_discussion!
    return false unless respond_to?(:discussion_locked=)

    update!(discussion_locked: true)
  end

  def unlock_discussion!
    return false unless respond_to?(:discussion_locked=)

    update!(discussion_locked: false)
  end

  # Check if user can create notes
  def user_can_create_note?(user)
    return false unless user
    return false if discussion_locked? && !user.can?(:admin, self)

    user.can?(:create_note, self)
  end

  # Check if user can view notes
  def user_can_view_notes?(user)
    return false unless user

    user.can?(:read_note, self)
  end

  def system_note_timestamp
    @system_note_timestamp || Time.current
  end

  attr_writer :system_note_timestamp
end
