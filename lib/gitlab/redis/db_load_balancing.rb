# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Redis
    class DbLoadBalancing < ::Gitlab::Redis::Wrapper
      class << self
        # The data we store on DbLoadBalancing used to be stored on SharedState.
        def config_fallback
          SharedState
        end
      end
    end
  end
end
