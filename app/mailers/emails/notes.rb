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
  module Notes
    def note_issue_email(recipient_id, note_id, reason = nil)
      setup_note_mail(note_id, recipient_id)

      @issue = @note.noteable
      @target_url = issue_url_for(@issue, anchor: "note_#{@note.id}")
      mail_answer_note_thread(@issue, @note, note_thread_options(reason))
    end

    def note_merge_request_email(recipient_id, note_id, reason = nil)
      setup_note_mail(note_id, recipient_id)

      @merge_request = @note.noteable
      @target_url = merge_request_url_for(@merge_request, anchor: "note_#{@note.id}")
      mail_answer_note_thread(@merge_request, @note, note_thread_options(reason))
    end

    private

    def note_thread_options(reason)
      noteable = @note.noteable
      {
        from: sender(@note.author_id),
        to: @recipient.notification_email_for,
        subject: subject("#{noteable.title} (##{noteable.iid})"),
        'X-Gisia-NotificationReason' => reason
      }
    end

    def setup_note_mail(note_id, recipient_id)
      @note = Note.find(note_id)
      @project = @note.project
      @recipient = User.find(recipient_id)
    end

    def issue_url_for(issue, anchor: nil)
      project = issue.project
      return '' unless project

      namespace_project_issue_url(
        project.namespace.parent.full_path,
        project.path,
        issue,
        anchor: anchor
      )
    end

    def merge_request_url_for(mr, anchor: nil)
      project = mr.target_project
      return '' unless project

      namespace_project_merge_request_url(
        project.namespace.parent.full_path,
        project.path,
        mr,
        anchor: anchor
      )
    end
  end
end
