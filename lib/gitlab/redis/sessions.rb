# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Redis
    class Sessions < ::Gitlab::Redis::Wrapper
      SESSION_NAMESPACE = 'session:gitlab'
      USER_SESSIONS_NAMESPACE = 'session:user:gitlab'
      USER_SESSIONS_LOOKUP_NAMESPACE = 'session:lookup:user:gitlab'
      IP_SESSIONS_LOOKUP_NAMESPACE = 'session:lookup:ip:gitlab2'
      OTP_SESSIONS_NAMESPACE = 'session:otp'

      # The data we store on Sessions used to be stored on SharedState.
      def self.config_fallback
        SharedState
      end
    end
  end
end
