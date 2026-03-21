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
  module WorkItems
    def new_work_item_email(recipient_id, work_item_id, reason = nil)
      setup_work_item_mail(work_item_id, recipient_id)

      mail_new_thread(@work_item, work_item_thread_options(@work_item.author_id, reason))
    end

    def closed_work_item_email(recipient_id, work_item_id, updated_by_user_id, reason: nil, closed_via: nil)
      setup_work_item_mail(work_item_id, recipient_id)

      @updated_by = User.find_by(id: updated_by_user_id)
      mail_answer_thread(@work_item, work_item_thread_options(updated_by_user_id, reason))
    end

    def work_item_status_changed_email(recipient_id, work_item_id, status, updated_by_user_id, reason = nil)
      setup_work_item_mail(work_item_id, recipient_id)

      @work_item_status = status
      @updated_by = User.find_by(id: updated_by_user_id)
      mail_answer_thread(@work_item, work_item_thread_options(updated_by_user_id, reason))
    end

    def reassigned_work_item_email(recipient_id, work_item_id, previous_assignee_ids, updated_by_user_id, reason = nil)
      setup_work_item_mail(work_item_id, recipient_id)

      previous_assignees = previous_assignee_ids.any? ? User.where(id: previous_assignee_ids).order(:id) : []
      @added_assignees = @work_item.assignees.map(&:name) - previous_assignees.map(&:name)
      @removed_assignees = previous_assignees.map(&:name) - @work_item.assignees.map(&:name)

      mail_answer_thread(@work_item, work_item_thread_options(updated_by_user_id, reason))
    end

    private

    def setup_work_item_mail(work_item_id, recipient_id)
      @work_item = WorkItem.find(work_item_id)
      @project = @work_item.project
      @namespace = @work_item.namespace
      @target_url = work_item_url_for(@work_item)
      @recipient = User.find(recipient_id)
      @work_item_label = @work_item.type
      @reference_prefix = @work_item.class.reference_prefix
    end

    def work_item_url_for(work_item, anchor: nil)
      project = work_item.project
      return '' unless project

      ns = project.namespace.parent.full_path
      path = project.path

      if work_item.is_a?(Epic)
        namespace_project_epic_url(ns, path, work_item, anchor: anchor)
      else
        namespace_project_issue_url(ns, path, work_item, anchor: anchor)
      end
    end

    def work_item_thread_options(sender_id, reason)
      {
        from: sender(sender_id),
        to: @recipient.notification_email_for,
        subject: subject("#{@work_item.title} (#{@reference_prefix}#{@work_item.iid})"),
        'X-Gisia-NotificationReason' => reason
      }
    end
  end
end
