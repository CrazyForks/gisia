# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module Partitionable
    module Testing
      InclusionError = Class.new(StandardError)

      PARTITIONABLE_MODELS = %w[
        CommitStatus
        Ci::BuildExecutionConfig
        Ci::BuildMetadata
        Ci::BuildName
        Ci::BuildNeed
        Ci::BuildReportResult
        Ci::BuildRunnerSession
        Ci::BuildSource
        Ci::BuildTag
        Ci::BuildTraceChunk
        Ci::BuildTraceMetadata
        Ci::BuildPendingState
        Ci::DailyBuildGroupReportResult
        Ci::JobAnnotation
        Ci::JobArtifact
        Ci::JobArtifactReport
        Ci::JobVariable
        Ci::Pipeline
        Ci::PendingBuild
        Ci::RunningBuild
        Ci::RunnerManagerBuild
        Ci::PipelineArtifact
        Ci::PipelineChatData
        Ci::PipelineConfig
        Ci::PipelineMessage
        Ci::PipelineMetadata
        Ci::PipelineVariable
        Ci::Sources::Pipeline
        Ci::Sources::Project
        Ci::Stage
        Ci::UnitTestFailure
      ].freeze

      def self.check_inclusion(klass)
        return if partitionable_models.include?(klass.name)

        raise Partitionable::Testing::InclusionError,
          "#{klass} must be included in PARTITIONABLE_MODELS"

      rescue InclusionError => e
        Gitlab::ErrorTracking.track_and_raise_for_dev_exception(e)
      end

      def self.partitionable_models
        PARTITIONABLE_MODELS
      end
    end
  end
end
