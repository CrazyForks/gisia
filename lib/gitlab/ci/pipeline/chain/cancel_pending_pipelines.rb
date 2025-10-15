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
        class CancelPendingPipelines < Chain::Base
          def perform!
            ::Ci::CancelRedundantPipelinesJob.perform_later(pipeline.id)
          end

          def break?
            false
          end
        end
      end
    end
  end
end
