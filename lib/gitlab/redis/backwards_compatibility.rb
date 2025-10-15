# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Redis
    module BackwardsCompatibility
      def lpop_with_limit(key, limit)
        Gitlab::Redis::SharedState.with do |redis|
          # To keep this compatible with Redis 6.0
          # use a Redis pipeline to pop all objects
          # instead of using lpop with limit.
          redis.pipelined do |pipeline|
            limit.times { pipeline.lpop(key) }
          end.compact
        end
      end
    end
  end
end
