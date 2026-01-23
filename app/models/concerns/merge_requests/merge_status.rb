# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module MergeRequests
  module MergeStatus
    extend ActiveSupport::Concern

    included do
      state_machine :merge_status, initial: :unchecked do
        event :mark_as_preparing do
          transition unchecked: :preparing
        end

        event :mark_as_unchecked do
          transition %i[preparing can_be_merged checking] => :unchecked
          transition %i[cannot_be_merged cannot_be_merged_rechecking] => :cannot_be_merged_recheck
        end

        event :mark_as_checking do
          transition unchecked: :checking
          transition cannot_be_merged_recheck: :cannot_be_merged_rechecking
        end

        event :mark_as_mergeable do
          transition %i[unchecked cannot_be_merged_recheck checking cannot_be_merged_rechecking] => :can_be_merged
        end

        event :mark_as_unmergeable do
          transition %i[unchecked cannot_be_merged_recheck checking
                        cannot_be_merged_rechecking] => :cannot_be_merged
        end

        state :preparing
        state :unchecked
        state :cannot_be_merged_recheck
        state :checking
        state :cannot_be_merged_rechecking
        state :can_be_merged
        state :cannot_be_merged

        around_transition do |merge_request, _transition, block|
          # Gitlab::Timeless.timeless(merge_request, &block)
        end

        after_transition any => %i[unchecked cannot_be_merged_recheck can_be_merged
                                   cannot_be_merged] do |merge_request, _transition|
          next if merge_request.skip_merge_status_trigger

          merge_request.run_after_commit do
            # GraphqlTriggers.merge_request_merge_status_updated(merge_request)
          end
        end

        after_transition %i[unchecked checking] => :cannot_be_merged do |merge_request, _transition|
          if merge_request.notify_conflict?
            merge_request.run_after_commit do
              # NotificationService.new.merge_request_unmergeable(merge_request)
            end

            # TodoService.new.merge_request_became_unmergeable(merge_request)
          end
        end
        def check_state?(merge_status)
          %i[unchecked cannot_be_merged_recheck checking cannot_be_merged_rechecking].include?(merge_status.to_sym)
        end

        # rubocop: disable Style/SymbolProc
        before_transition { |merge_request| merge_request.enable_transitioning }

        after_transition { |merge_request| merge_request.disable_transitioning }
        # rubocop: enable Style/SymbolProc
      end
    end
  end
end
