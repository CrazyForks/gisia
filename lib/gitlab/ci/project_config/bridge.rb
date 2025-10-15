# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class ProjectConfig
      class Bridge < Source
        def content
          return unless pipeline_source_bridge

          pipeline_source_bridge.yaml_for_downstream
        end

        # Bridge.yaml_for_downstream injects an `include`
        def internal_include_prepended?
          true
        end

        def source
          :bridge_source
        end
      end
    end
  end
end
