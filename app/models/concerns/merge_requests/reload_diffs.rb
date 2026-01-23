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
  module ReloadDiffs
    extend ActiveSupport::Concern

    included do
      after_update :reload_diff_if_branch_changed
    end

    def source_branch_head
      strong_memoize(:source_branch_head) do
        source_project.repository.commit(source_branch_ref) if source_project && source_branch_ref
      end
    end

    def target_branch_head
      strong_memoize(:target_branch_head) do
        target_project.repository.commit(target_branch_ref)
      end
    end

    def reload_diff_if_branch_changed
      if (saved_change_to_source_branch? || saved_change_to_target_branch?) &&
         source_branch_head && target_branch_head
        reload_diff
      end
    end

    def reload_diff(current_user = nil)
      return unless open?

      # Todo, update tracer
      # MergeRequests::ReloadDiffsService.new(self, current_user).execute
    end

    def diff_refs
      if importing? || persisted?
        merge_request_diff.diff_refs
      else
        repository_diff_refs
      end
    end
  end
end
