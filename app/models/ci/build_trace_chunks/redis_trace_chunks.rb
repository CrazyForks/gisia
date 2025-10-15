# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Ci
  module BuildTraceChunks
    class RedisTraceChunks < RedisBase
      private

      def with_redis
        Gitlab::Redis::TraceChunks.with { |redis| yield(redis) }
      end
    end
  end
end
