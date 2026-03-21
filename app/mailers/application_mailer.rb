# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class ApplicationMailer < ActionMailer::Base
  around_action :render_with_default_locale

  helper ApplicationHelper
  helper EmailsHelper

  default from: proc { default_sender_address.format }
  default reply_to: proc { default_reply_to_address.format }

  layout 'mailer'

  private

  def subject(*extra)
    parts = []
    parts << @project.name if @project
    parts << @namespace.name if @namespace && !@project
    parts.concat(extra) if extra.present?

    EmailsHelper.subject_with_prefix_and_suffix(parts)
  end

  def render_with_default_locale(&block)
    Gitlab::I18n.with_default_locale(&block)
  end

  def mail_with_locale(headers = {}, &block)
    locale = recipient_locale(headers)
    Gitlab::I18n.with_locale(locale) do
      mail(headers, &block)
    end
  end

  def recipient_locale(headers = {})
    to = Array(headers[:to])
    to.one? ? preferred_language_by_email(to.first) : I18n.locale
  end

  def preferred_language_by_email(email)
    User.find_by(email: email)&.preferred_language || I18n.locale
  end

  def default_sender_address
    address = Mail::Address.new(Gitlab.config.gitlab.email_from)
    address.display_name = Gitlab.config.gitlab.email_display_name
    address
  end

  def default_reply_to_address
    address = Mail::Address.new(Gitlab.config.gitlab.email_reply_to)
    address.display_name = Gitlab.config.gitlab.email_display_name
    address
  end
end
