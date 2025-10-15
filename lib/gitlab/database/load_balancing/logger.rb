# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    module LoadBalancing
      class Logger < ::Gitlab::JsonLogger
        exclude_context!

        def self.file_name_noext
          'database_load_balancing'
        end
      end
    end
  end
end
