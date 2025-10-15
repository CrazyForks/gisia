# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module MergeRequests
  module Status
    extend ActiveSupport::Concern

    TITLE_LENGTH_MAX = 255
    DESCRIPTION_LENGTH_MAX = 1.megabyte
    SEARCHABLE_FIELDS = %w[title description].freeze
    MAX_NUMBER_OF_ASSIGNEES_OR_REVIEWERS = 200

    included do
      belongs_to :author, class_name: 'User'

      enum :status, {
        opened: 1,
        closed: 2,
        merged: 3,
        locked: 4
      }

      state_machine :status, initial: :opened, initialize: false do
        event :close do
          transition [:opened] => :closed
        end

        event :mark_as_merged do
          transition %i[opened locked] => :merged
        end

        event :reopen do
          transition closed: :opened
        end

        event :lock_mr do
          transition [:opened] => :locked
        end

        event :unlock_mr do
          transition locked: :opened
        end

        before_transition any => %i[opened merged] do |merge_request|
          merge_request.merge_jid = nil
        end

        before_transition any => :closed do |merge_request|
          merge_request.merge_error = nil
        end

        before_transition any => :merged do |merge_request|
          merge_request.merge_error = nil
        end

        after_transition any => :opened do |merge_request|
          merge_request.run_after_commit do
            # UpdateHeadPipelineForMergeRequestWorker.perform_async(merge_request.id)
          end
        end
      end

      def open?
        opened?
      end
    end
  end
end
