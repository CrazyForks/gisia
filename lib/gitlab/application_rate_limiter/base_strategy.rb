# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module ApplicationRateLimiter
    class BaseStrategy
      # Increment the rate limit count and return the new count value
      def increment(cache_key, expiry)
        raise NotImplementedError
      end

      # Return the rate limit count.
      # Should be 0 if there is no data in the cache.
      def read(cache_key)
        raise NotImplementedError
      end

      private

      def with_redis(&block)
        ::Gitlab::Redis::RateLimiting.with_suppressed_errors(&block)
      end
    end
  end
end
