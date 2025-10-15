# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Instrumentation
    class Throttle
      KEY = :instrumentation_throttle_safelist

      def self.safelist
        Gitlab::SafeRequestStore[KEY]
      end

      def self.safelist=(name)
        Gitlab::SafeRequestStore[KEY] = name
      end
    end
  end
end
