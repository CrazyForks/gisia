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
        class Build < Chain::Base
          def perform!
            @pipeline.assign_attributes(
              source: @command.source,
              project: @command.project,
              ref: @command.ref,
              sha: @command.sha,
              before_sha: @command.before_sha,
              source_sha: @command.source_sha,
              target_sha: @command.target_sha,
              tag: @command.tag_exists?,
              user: @command.current_user,
              merge_request: @command.merge_request
            )
          end

          def break?
            @pipeline.errors.any?
          end
        end
      end
    end
  end
end
