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
        # During linting, we don't want to persist the pipeline so we skip
        # all the following steps that operate on persisted objects.
        # This class allows us to exit the pipeline creation chain when we're done linting.
        class StopLinting < Chain::Base
          def perform!
            # no-op
          end

          def break?
            @command.linting?
          end
        end
      end
    end
  end
end
