# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class ProjectConfig
      class Parameter < Source
        def content
          strong_memoize(:content) do
            next unless custom_content.present?

            custom_content
          end
        end

        def source
          :parameter_source
        end
      end
    end
  end
end
