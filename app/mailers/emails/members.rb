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
  module Members
    def member_access_granted_email(member_id)
      @member = Member.find_by(id: member_id)
      return unless @member&.user

      @namespace = @member.namespace

      mail_with_locale(
        to: @member.user.notification_email_for,
        subject: subject("Access to #{@namespace.full_name} was granted")
      ) do |format|
        format.html { render layout: 'mailer' }
        format.text { render layout: 'mailer' }
      end
    end
  end
end
