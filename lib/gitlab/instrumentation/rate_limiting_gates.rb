# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Instrumentation
    class RateLimitingGates
      GATES = :rate_limiting_gates

      class << self
        def track(key)
          if ::Gitlab::SafeRequestStore.active?
            gates_set << key
          end
        end

        def gates
          gates_set.to_a
        end

        def payload
          {
            GATES => gates
          }
        end

        private

        def gates_set
          ::Gitlab::SafeRequestStore[GATES] ||= Set.new
        end
      end
    end
  end
end
