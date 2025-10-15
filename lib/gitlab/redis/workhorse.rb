# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Redis
    class Workhorse < ::Gitlab::Redis::Wrapper
      class << self
        def config_fallback
          SharedState
        end
      end
    end
  end
end
