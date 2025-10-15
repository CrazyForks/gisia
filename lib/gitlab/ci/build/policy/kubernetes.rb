# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      module Policy
        class Kubernetes < Policy::Specification
          def initialize(spec)
            unless spec.to_sym == :active
              raise UnknownPolicyError
            end
          end

          def satisfied_by?(pipeline, context = nil)
            pipeline.has_kubernetes_active?
          end
        end
      end
    end
  end
end
