# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Redis
    class FeatureFlag < ::Gitlab::Redis::Wrapper
      FeatureFlagStore = Class.new(ActiveSupport::Cache::RedisCacheStore)

      class << self
        # The data we store on FeatureFlag is currently stored on Cache.
        def config_fallback
          Cache
        end

        def cache_store
          @cache_store ||= FeatureFlagStore.new(
            redis: pool,
            pool: false,
            compress: Gitlab::Utils.to_boolean(ENV.fetch('ENABLE_REDIS_CACHE_COMPRESSION', '1')),
            namespace: Cache::CACHE_NAMESPACE,
            expires_in: 1.hour
          )
        end
      end
    end
  end
end
