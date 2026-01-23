# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module WorkItems
  module HasState
    extend ActiveSupport::Concern

    STATE_ID_MAP = {
      opened: 1,
      closed: 2
    }.with_indifferent_access.freeze

    included do
      enum :state_id, STATE_ID_MAP

      state_machine :state_id, initial: :opened, initialize: false do
        event :close do
          transition [:opened] => :closed
        end

        event :reopen do
          transition closed: :opened
        end

        before_transition any => :closed do |issue, transition|
          args = transition.args

          issue.closed_at = issue.system_note_timestamp

          next if args.empty?

          next unless args.first.is_a?(User)

          issue.closed_by = args.first
        end

        before_transition closed: :opened do |issue|
          issue.closed_at = nil
          issue.closed_by = nil

          issue.clear_closure_reason_references
        end
      end
    end

    def system_note_timestamp
      Time.current
    end

    def clear_closure_reason_references
      # Implementation for clearing closure reason references
    end
  end
end
