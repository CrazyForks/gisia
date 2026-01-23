# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Git
  module MergeRequests
    module Refreshable
      extend ActiveSupport::Concern

      def refresh!
        @push = Gitlab::Git::Push.new(project, oldrev, newrev, ref)

        Gitlab::GitalyClient.allow_n_plus_1_calls { find_new_commits }
        reload_merge_requests
        refresh_mrs!
      end

      private

      def find_new_commits
        if @push.branch_added?
          @commits = []

          merge_request = merge_requests_for_source_branch.first
          return unless merge_request

          begin
            # Since any number of commits could have been made to the restored branch,
            # find the common root to see what has been added.
            common_ref = project.repository.merge_base(merge_request.diff_head_sha, @push.newrev)
            # If the a commit no longer exists in this repo, gitlab_git throws
            # a Rugged::OdbError. This is fixed in https://gitlab.com/gitlab-org/gitlab_git/merge_requests/52
            @commits = project.repository.commits_between(common_ref, @push.newrev) if common_ref
          rescue StandardError
          end
        elsif @push.branch_removed?
          # No commits for a deleted branch.
          @commits = []
        else
          @commits = @project.repository.commits_between(@push.oldrev, @push.newrev)
        end
      end

      def merge_requests_for_source_branch(reload: false)
        @source_merge_requests = nil if reload
        @source_merge_requests ||= project.merge_requests_for(@push.branch_name)
      end

      def reload_merge_requests
        project.merge_requests.opened
               .by_source_or_target_branch(@push.branch_name)
               .preload_project_and_latest_diff.each do |merge_request|
          if branch_and_project_match?(merge_request) || @push.force_push?
            merge_request.reload_diff(current_user)
          elsif merge_request.merge_request_diff.includes_any_commits?(push_commit_ids)
            merge_request.reload_diff(current_user)
          end
        end
        merge_requests_for_source_branch(reload: true)
      end

      def push_commit_ids
        @push_commit_ids ||= @commits.map(&:id)
      end

      def refresh_mrs!
        merge_requests_for_source_branch.each do |mr|
          refresh_pipelines_on_merge_request(mr) unless @push.branch_removed?
        end
      end

      def refresh_pipelines_on_merge_request(merge_request, allow_duplicate: false)
        create_pipeline_for(merge_request, async: true, allow_duplicate: allow_duplicate)
      end

      def create_pipeline_for(merge_request, async:, allow_duplicate:)
        return unless can_create_pipeline_for?(merge_request)

        pipeline_options = { merge_request: merge_request }

        Ci::Pipeline.build_from(project, current_user, mr_pipeline_params.merge(allow_duplicate: allow_duplicate),
          :merge_request_event, pipeline_options)
      end

      def can_create_pipeline_for?(merge_request)
        ##
        # UpdateMergeRequestsWorker could be retried by an exception.
        # pipelines for merge request should not be recreated in such case.
        return false if !allow_duplicate && merge_request.find_diff_head_pipeline&.merge_request?
        return false if merge_request.has_no_commits?

        true
      end

      def branch_and_project_match?(merge_request)
        merge_request.source_project == project &&
          merge_request.source_branch == @push.branch_name
      end

      def mr_pipeline_params
        {
          ref: ref,
          push_options: params[:push_options],
          pipeline_creation_request: params[:pipeline_creation_request],
          gitaly_context: params[:gitaly_context]
        }
      end

      def allow_duplicate
        params[:allow_duplicate]
      end
    end
  end
end
