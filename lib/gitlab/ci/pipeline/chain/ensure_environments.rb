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
        class EnsureEnvironments < Chain::Base
          def perform!
            pipeline.stages.flat_map(&:statuses).each(&method(:ensure_environment))
          end

          def break?
            false
          end

          private

          def ensure_environment(build)
            ::Environments::CreateForJobService.new.execute(build)
          end
        end
      end
    end
  end
end
