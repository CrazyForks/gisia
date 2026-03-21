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
  module Issues
    def new_issue_email(recipient_id, issue_id, reason = nil)
      setup_issue_mail(issue_id, recipient_id)

      mail_new_thread(@issue, issue_thread_options(@issue.author_id, reason))
    end

    def closed_issue_email(recipient_id, issue_id, updated_by_user_id, reason: nil, closed_via: nil)
      setup_issue_mail(issue_id, recipient_id)

      @updated_by = User.find_by(id: updated_by_user_id)
      mail_answer_thread(@issue, issue_thread_options(updated_by_user_id, reason))
    end

    def issue_status_changed_email(recipient_id, issue_id, status, updated_by_user_id, reason = nil)
      setup_issue_mail(issue_id, recipient_id)

      @issue_status = status
      @updated_by = User.find_by(id: updated_by_user_id)
      mail_answer_thread(@issue, issue_thread_options(updated_by_user_id, reason))
    end

    def reassigned_issue_email(recipient_id, issue_id, previous_assignee_ids, updated_by_user_id, reason = nil)
      setup_issue_mail(issue_id, recipient_id)

      previous_assignees = previous_assignee_ids.any? ? User.where(id: previous_assignee_ids).order(:id) : []
      @added_assignees = @issue.assignees.map(&:name) - previous_assignees.map(&:name)
      @removed_assignees = previous_assignees.map(&:name) - @issue.assignees.map(&:name)

      mail_answer_thread(@issue, issue_thread_options(updated_by_user_id, reason))
    end

    private

    def setup_issue_mail(issue_id, recipient_id)
      @issue = WorkItem.find(issue_id)
      @project = @issue.project
      @namespace = @issue.namespace
      @target_url = issue_url_for(@issue)
      @recipient = User.find(recipient_id)
    end

    def issue_url_for(issue)
      project = issue.project
      return '' unless project

      namespace_project_issue_url(
        project.namespace.parent.full_path,
        project.path,
        issue
      )
    end

    def issue_thread_options(sender_id, reason)
      {
        from: sender(sender_id),
        to: @recipient.notification_email_for,
        subject: subject("#{@issue.title} (##{@issue.iid})"),
        'X-Gisia-NotificationReason' => reason
      }
    end
  end
end
