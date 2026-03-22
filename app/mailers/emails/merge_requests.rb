# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Emails
  module MergeRequests
    def new_merge_request_email(recipient_id, merge_request_id, reason = nil)
      setup_merge_request_mail(merge_request_id, recipient_id)

      mail_new_thread(@merge_request, merge_request_thread_options(@merge_request.author_id, reason))
    end

    def closed_merge_request_email(recipient_id, merge_request_id, updated_by_user_id, reason: nil)
      setup_merge_request_mail(merge_request_id, recipient_id)

      @updated_by = User.find_by(id: updated_by_user_id)
      mail_answer_thread(@merge_request, merge_request_thread_options(updated_by_user_id, reason))
    end

    def merged_merge_request_email(recipient_id, merge_request_id, updated_by_user_id, reason: nil)
      setup_merge_request_mail(merge_request_id, recipient_id)

      @updated_by = User.find_by(id: updated_by_user_id)
      mail_answer_thread(@merge_request, merge_request_thread_options(updated_by_user_id, reason))
    end

    def reassigned_merge_request_email(recipient_id, merge_request_id, previous_assignee_ids, updated_by_user_id, reason = nil)
      setup_merge_request_mail(merge_request_id, recipient_id)

      previous_assignees = previous_assignee_ids.any? ? User.where(id: previous_assignee_ids) : []
      @added_assignees = @merge_request.assignees.map(&:name) - previous_assignees.map(&:name)
      @removed_assignees = previous_assignees.map(&:name) - @merge_request.assignees.map(&:name)

      mail_answer_thread(@merge_request, merge_request_thread_options(updated_by_user_id, reason))
    end

    def reopened_merge_request_email(recipient_id, merge_request_id, status, updated_by_user_id, reason = nil)
      setup_merge_request_mail(merge_request_id, recipient_id)

      @updated_by = User.find_by(id: updated_by_user_id)
      @status = status
      mail_answer_thread(@merge_request, merge_request_thread_options(updated_by_user_id, reason))
    end

    def changed_reviewer_of_merge_request_email(recipient_id, merge_request_id, previous_reviewer_ids, updated_by_user_id, reason = nil)
      setup_merge_request_mail(merge_request_id, recipient_id)

      @previous_reviewers = previous_reviewer_ids.any? ? User.where(id: previous_reviewer_ids) : []
      @updated_by_user = User.find_by(id: updated_by_user_id)

      mail_answer_thread(@merge_request, merge_request_thread_options(updated_by_user_id, reason))
    end

    private

    def setup_merge_request_mail(merge_request_id, recipient_id)
      @merge_request = MergeRequest.find(merge_request_id)
      @project = @merge_request.target_project
      @target_url = merge_request_url_for(@merge_request)
      @recipient = User.find(recipient_id)
    end

    def merge_request_url_for(mr)
      project = mr.target_project
      return '' unless project

      namespace_project_merge_request_url(
        project.namespace.parent.full_path,
        project.path,
        mr
      )
    end

    def merge_request_thread_options(sender_id, reason)
      {
        from: sender(sender_id),
        to: @recipient.notification_email_for,
        subject: subject("#{@merge_request.title} (!#{@merge_request.iid})"),
        'X-Gisia-NotificationReason' => reason
      }
    end
  end
end
