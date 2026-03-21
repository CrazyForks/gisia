# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

unless Gitlab.config.gitlab.email_enabled
  ActionMailer::Base.register_interceptor(::Gitlab::Email::Hook::DisableEmailInterceptor)
  ActionMailer::Base.logger = nil
end

ActionMailer::Base.register_interceptors(
  ::Gitlab::Email::Hook::AdditionalHeadersInterceptor
)
