# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Email
    module Hook
      class AdditionalHeadersInterceptor
        def self.delivering_email(message)
          message.header['Auto-Submitted'] ||= 'auto-generated'
          message.header['X-Auto-Response-Suppress'] ||= 'All'
        end
      end
    end
  end
end
