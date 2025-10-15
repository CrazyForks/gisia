# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Redis
    class TraceChunks < ::Gitlab::Redis::MultiStoreWrapper
      class << self
        # The data we store on TraceChunks used to be stored on SharedState.
        def config_fallback
          SharedState
        end

        def multistore
          MultiStore.create_using_pool(MemoryStoreTraceChunks.pool, pool, store_name)
        end
      end
    end
  end
end
