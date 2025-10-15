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
        class RemoveUnwantedChatJobs < Chain::Base
          def perform!
            raise ArgumentError, 'missing YAML processor result' unless @command.yaml_processor_result

            return unless pipeline.chat?

            # When scheduling a chat pipeline we only want to run the build
            # that matches the chat command.
            @command.yaml_processor_result.jobs.select! do |name, _|
              name.to_s == command.chat_data[:command].to_s
            end
          end

          def break?
            false
          end
        end
      end
    end
  end
end
