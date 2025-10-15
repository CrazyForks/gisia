# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module ActionCable
    class Config
      class << self
        def worker_pool_size
          ENV.fetch('ACTION_CABLE_WORKER_POOL_SIZE', 4).to_i
        end
      end
    end
  end
end
