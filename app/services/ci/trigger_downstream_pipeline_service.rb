# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================


module Ci
  # Enqueues the downstream pipeline worker.
  class TriggerDownstreamPipelineService
    def initialize(bridge)
      @bridge = bridge
      @current_user = bridge.user
      @project = bridge.project
      @pipeline = bridge.pipeline
    end

    def execute
      unless bridge.triggers_downstream_pipeline?
        return ServiceResponse.success(message: 'Does not trigger a downstream pipeline')
      end

      create_downstream_pipeline(bridge)

      ServiceResponse.success(message: 'Downstream pipeline enqueued')
    end

    private

    attr_reader :bridge, :current_user, :project, :pipeline

    def create_throttled_log_entry
      ::Gitlab::AppJsonLogger.info(
        class: self.class.name,
        project_id: project.id,
        current_user_id: current_user.id,
        pipeline_sha: pipeline.sha,
        subscription_plan: project.actual_plan_name,
        downstream_type: bridge.triggers_child_pipeline? ? 'child' : 'multi-project',
        message: 'Activated downstream pipeline trigger rate limit'
      )
    end

    def create_downstream_pipeline(bridge)
      ::Ci::CreateDownstreamPipelineService
        .new(bridge.project, bridge.user)
        .execute(bridge)
    end
  end
end
