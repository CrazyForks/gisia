# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module HasMergeRequest
    extend ActiveSupport::Concern

    MAX_OPEN_MERGE_REQUESTS_REFS = 4

    def merge_request?
      merge_request_id.present? && merge_request.present?
    end

    def detached_merge_request_pipeline?
      merge_request? && target_sha.nil?
    end

    def merge_request_ref?
      MergeRequest.merge_request_ref?(ref)
    end

    def legacy_detached_merge_request_pipeline?
      detached_merge_request_pipeline? && !merge_request_ref?
    end

    # This returns a list of MRs that point
    # to the same source project/branch
    def related_merge_requests
      if merge_request?
        # We look for all other MRs that this branch might be pointing to
        MergeRequest.where(
          source_project_id: merge_request.source_project_id,
          source_branch: merge_request.source_branch
        )
      else
        MergeRequest.where(
          source_project_id: project_id,
          source_branch: ref
        )
      end
    end

    # We cannot use `all_merge_requests`, due to race condition
    # This returns a list of at most 4 open MRs
    def open_merge_requests_refs
      strong_memoize(:open_merge_requests_refs) do
        # We ensure that triggering user can actually read the pipeline
        related_merge_requests
          .opened
          .limit(MAX_OPEN_MERGE_REQUESTS_REFS)
          .order(id: :desc)
          .preload(:target_project)
          .select { |mr| can?(user, :read_merge_request, mr) }
          .map { |mr| mr.to_reference(project, full: true) }
      end
    end

    def can?(_user, _read_merge_request, _mr)
      # Todo,
      true
    end

    def merged_result_pipeline?
      merge_request? && target_sha.present?
    end

    def detached_merge_request_pipeline?
      merge_request? && target_sha.nil?
    end

    def merge_request_event_type
      return unless merge_request?

      strong_memoize(:merge_request_event_type) do
        if merged_result_pipeline?
          :merged_result
        elsif detached_merge_request_pipeline?
          :detached
        end
      end
    end

    def merge_request_diff
      return unless merge_request?

      merge_request.merge_request_diff_for(merge_request_diff_sha)
    end

    def merge_request_diff_sha
      return unless merge_request?

      if merged_result_pipeline?
        source_sha
      else
        sha
      end
    end
  end
end
