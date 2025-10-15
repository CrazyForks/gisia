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
        module PipelineExecutionPolicies
          class EvaluatePolicies < Chain::Base
            # rubocop:disable Gitlab/NoCodeCoverageComment -- EE module is tested
            # :nocov:
            def perform!
              # to be overridden in EE
            end

            def break?
              false # to be overridden in EE
            end
            # :nocov:
            # rubocop:enable Gitlab/NoCodeCoverageComment
          end
        end
      end
    end
  end
end

Gitlab::Ci::Pipeline::Chain::PipelineExecutionPolicies::EvaluatePolicies.prepend_mod
