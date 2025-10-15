# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Instrumentation
    module Middleware
      class PathTraversalCheck
        DURATION_LABEL = :path_traversal_check_duration_s

        def self.duration=(duration)
          return unless Gitlab::SafeRequestStore.active?

          ::Gitlab::SafeRequestStore[DURATION_LABEL] = ::Gitlab::InstrumentationHelper.round_elapsed_time(0, duration)
        end

        def self.duration
          ::Gitlab::SafeRequestStore[DURATION_LABEL] || 0
        end

        def self.payload
          { DURATION_LABEL => duration }
        end
      end
    end
  end
end
