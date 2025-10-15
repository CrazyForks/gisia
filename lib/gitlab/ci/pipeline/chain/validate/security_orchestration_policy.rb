# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Pipeline
      module Chain
        module Validate
          class SecurityOrchestrationPolicy < Chain::Base
            include Chain::Helpers

            def perform!
              # no-op
            end

            def break?
              false
            end
          end
        end
      end
    end
  end
end

Gitlab::Ci::Pipeline::Chain::Validate::SecurityOrchestrationPolicy.prepend_mod_with('Gitlab::Ci::Pipeline::Chain::Validate::SecurityOrchestrationPolicy')
