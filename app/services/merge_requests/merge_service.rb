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
  class MergeService
    MergeError = Class.new(StandardError)

    GENERIC_ERROR_MESSAGE = 'An error occurred while merging'

    attr_reader :merge_request, :current_user

    def initialize(merge_request:, current_user:)
      @merge_request = merge_request
      @current_user = current_user
    end

    def execute
      return error('Merge request is not open') unless merge_request.opened?
      return error('No source for merge') if merge_request.diff_head_sha.blank?

      lease = merge_request.merge_exclusive_lease
      return error('Merge request is already being merged') unless lease.try_obtain

      merge_request.in_locked_state do
        commit_sha = perform_merge
        raise MergeError, GENERIC_ERROR_MESSAGE unless commit_sha

        merge_request.update!(
          merge_commit_sha: commit_sha,
          merged_commit_sha: commit_sha,
          merge_user: current_user
        )
        merge_request.mark_as_merged
        merge_request.metrics.update!(merged_by: current_user, merged_at: Time.current)
      end

      success
    rescue MergeError => e
      merge_request.update(merge_error: e.message)
      error(e.message)
    rescue StandardError => e
      merge_request.update(merge_error: "#{e.class}: #{e.message}")
      error("#{e.class}: #{e.message}")
    ensure
      lease&.cancel
    end

    private

    def perform_merge
      source_sha = merge_request.diff_head_sha
      message = merge_request.default_merge_commit_message(user: current_user)

      merge_request.target_project.repository.merge(
        current_user,
        source_sha,
        merge_request,
        message
      )
    end

    def success
      { status: :success }
    end

    def error(message)
      { status: :error, message: message }
    end
  end
end
