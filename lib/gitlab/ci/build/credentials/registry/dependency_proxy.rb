# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      module Credentials
        module Registry
          class DependencyProxy < GitlabRegistry
            def url
              Gitlab.host_with_port
            end

            def valid?
              Gitlab.config.dependency_proxy.enabled
            end
          end
        end
      end
    end
  end
end
