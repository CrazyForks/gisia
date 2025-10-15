# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class ProjectConfig
      class Compliance < Gitlab::Ci::ProjectConfig::Source
        # rubocop:disable Gitlab/NoCodeCoverageComment -- overridden and tested in EE
        # :nocov:
        def content
          nil
        end
        # :nocov:
        # rubocop:enable Gitlab/NoCodeCoverageComment

        def internal_include_prepended?
          true
        end

        def source
          :compliance_source
        end
      end
    end
  end
end

Gitlab::Ci::ProjectConfig::Compliance.prepend_mod
