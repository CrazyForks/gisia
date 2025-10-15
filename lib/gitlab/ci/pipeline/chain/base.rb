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
        class Base
          attr_reader :pipeline, :command, :config

          delegate :project, :current_user, :parent_pipeline, :logger, to: :command

          def initialize(pipeline, command)
            @pipeline = pipeline
            @command = command
          end

          def perform!
            raise NotImplementedError
          end

          def break?
            raise NotImplementedError
          end
        end
      end
    end
  end
end
