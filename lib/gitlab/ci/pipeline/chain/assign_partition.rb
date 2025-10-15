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
        class AssignPartition < Chain::Base
          include Chain::Helpers

          def perform!
            @pipeline.partition_id = find_partition_id
          end

          def break?
            @pipeline.errors.any?
          end

          private

          def find_partition_id
            if @command.partition_id
              @command.partition_id
            elsif @command.creates_child_pipeline?
              @command.parent_pipeline_partition_id
            else
              ::Ci::Pipeline.current_partition_value
            end
          end
        end
      end
    end
  end
end
