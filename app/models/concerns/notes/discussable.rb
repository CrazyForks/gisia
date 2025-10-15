# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Notes
  module Discussable
    extend ActiveSupport::Concern

    included do
      belongs_to :parent_note, class_name: 'Note', foreign_key: 'discussion_id', optional: true
      has_many :replies, class_name: 'Note', foreign_key: 'discussion_id'

      scope :root_notes, -> { where(discussion_id: nil) }
      scope :reply_notes, -> { where.not(discussion_id: nil) }
      scope :discussions, -> { where(discussion_id: nil) }
    end

    class_methods do
    end

    def first_note
      self
    end

    def notes
      Note.where(id: id).or(Note.where(discussion_id: id))
    end

    def discussion
      if discussion_id.present?
        parent_note
      else
        self
      end
    end

    def start_of_discussion?
      discussion.first_note == self
    end

    # Instance methods
    def discussable?
      !system?
    end

    def can_be_discussion_note?
      !system?
    end

    def root_note?
      discussion_id.nil?
    end

    def reply?
      discussion_id.present?
    end

    def has_replies?
      replies.exists?
    end

    def reply_count
      replies.count
    end
  end
end
