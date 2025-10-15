# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class ProjectConfig
      class AutoDevops < Source
        def content
          strong_memoize(:content) do
            next unless project&.auto_devops_enabled?

            template = Gitlab::Template::GitlabCiYmlTemplate.find(template_name)
            ci_yaml_include({ 'template' => template.full_name })
          end
        end

        def internal_include_prepended?
          true
        end

        def source
          :auto_devops_source
        end

        private

        def template_name
          'Auto-DevOps'
        end
      end
    end
  end
end
