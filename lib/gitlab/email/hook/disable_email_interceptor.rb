# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Email
    module Hook
      class DisableEmailInterceptor
        def self.delivering_email(message)
          message.perform_deliveries = false

          Gitlab::AppLogger.info "Emails disabled! Interceptor prevented sending mail #{message.subject}"
        end
      end
    end
  end
end
