# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Redis
    class RateLimiting < ::Gitlab::Redis::Wrapper
      class << self
        # The data we store on RateLimiting used to be stored on Cache.
        def config_fallback
          Cache
        end

        # Rescue Redis errors so we do not take the site down when the rate limiting instance is down
        def with_suppressed_errors(&block)
          with(&block)
        rescue ::Redis::BaseError, ::RedisClient::Error => e
          Gitlab::ErrorTracking.track_and_raise_for_dev_exception(e)
        end
      end
    end
  end
end
