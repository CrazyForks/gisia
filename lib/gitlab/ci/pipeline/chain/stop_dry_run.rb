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
        # During the dry run we don't want to persist the pipeline and skip
        # all the other steps that operate on a persisted context.
        # This causes the chain to break at this point.
        class StopDryRun < Chain::Base
          def perform!
            # no-op
          end

          def break?
            @command.dry_run?
          end
        end
      end
    end
  end
end
