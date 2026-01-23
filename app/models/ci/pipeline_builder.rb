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
  class PipelineBuilder
    attr_accessor :project, :current_user, :params, :pipeline, :logger

    LOG_MAX_DURATION_THRESHOLD = 3.seconds
    LOG_MAX_PIPELINE_SIZE = 2_000
    LOG_MAX_CREATION_THRESHOLD = 20.seconds
    SEQUENCE = [Gitlab::Ci::Pipeline::Chain::Build,
                Gitlab::Ci::Pipeline::Chain::Validate::Abilities,
                Gitlab::Ci::Pipeline::Chain::Validate::Repository,
                Gitlab::Ci::Pipeline::Chain::Build::Associations,
                Gitlab::Ci::Pipeline::Chain::Limit::RateLimit,
                # empty in ce
                Gitlab::Ci::Pipeline::Chain::Validate::SecurityOrchestrationPolicy,
                # Gitlab::Ci::Pipeline::Chain::AssignPartition,
                # empty in ce
                # Gitlab::Ci::Pipeline::Chain::PipelineExecutionPolicies::EvaluatePolicies,
                Gitlab::Ci::Pipeline::Chain::Skip,
                Gitlab::Ci::Pipeline::Chain::Validate::Config,
                Gitlab::Ci::Pipeline::Chain::Config::Content,
                Gitlab::Ci::Pipeline::Chain::Config::Process,
                Gitlab::Ci::Pipeline::Chain::StopLinting,
                Gitlab::Ci::Pipeline::Chain::Validate::AfterConfig,
                Gitlab::Ci::Pipeline::Chain::RemoveUnwantedChatJobs,
                Gitlab::Ci::Pipeline::Chain::SeedBlock,
                Gitlab::Ci::Pipeline::Chain::EvaluateWorkflowRules,
                Gitlab::Ci::Pipeline::Chain::Seed,
                # Todo, size on parent namespace
                Gitlab::Ci::Pipeline::Chain::Limit::Size,
                Gitlab::Ci::Pipeline::Chain::Limit::ActiveJobs,
                Gitlab::Ci::Pipeline::Chain::Limit::Deployments,
                Gitlab::Ci::Pipeline::Chain::Validate::External,
                Gitlab::Ci::Pipeline::Chain::SetBuildSources,
                Gitlab::Ci::Pipeline::Chain::Populate,
                Gitlab::Ci::Pipeline::Chain::PopulateMetadata,
                # emtpy in ee
                Gitlab::Ci::Pipeline::Chain::PipelineExecutionPolicies::ApplyPolicies,
                Gitlab::Ci::Pipeline::Chain::StopDryRun,
                # Not supported yet
                # Gitlab::Ci::Pipeline::Chain::EnsureEnvironments,
                # Gitlab::Ci::Pipeline::Chain::EnsureResourceGroups,
                Gitlab::Ci::Pipeline::Chain::Create,
                # emtpy in ce
                Gitlab::Ci::Pipeline::Chain::CreateCrossDatabaseAssociations,
                Gitlab::Ci::Pipeline::Chain::CancelPendingPipelines,
                Gitlab::Ci::Pipeline::Chain::Metrics,
                # not needed
                # Gitlab::Ci::Pipeline::Chain::TemplateUsage,
                # Gitlab::Ci::Pipeline::Chain::ComponentUsage,
                # Gitlab::Ci::Pipeline::Chain::KeywordUsage,
                Gitlab::Ci::Pipeline::Chain::Pipeline::Process].freeze

    def initialize(project, user, params)
      @project = project
      @current_user = user
      @params = params.dup
    end

    def build!(source,
               ignore_skip_ci: false, save_on_errors: true, schedule: nil, merge_request: nil,
               external_pull_request: nil, bridge: nil, inputs: {},
               **, &block)
      @logger = build_logger
      @command_logger = Gitlab::Ci::Pipeline::CommandLogger.new
      @pipeline = Ci::Pipeline.new

      command ||= Gitlab::Ci::Pipeline::Chain::Command.new(
        source: source,
        origin_ref: params[:ref],
        checkout_sha: params[:checkout_sha],
        after_sha: params[:after],
        before_sha: params[:before],          # The base SHA of the source branch (i.e merge_request.diff_base_sha).
        source_sha: params[:source_sha],      # The HEAD SHA of the source branch (i.e merge_request.diff_head_sha).
        target_sha: params[:target_sha],      # The HEAD SHA of the target branch.
        schedule: schedule,
        merge_request: merge_request,
        external_pull_request: external_pull_request,
        ignore_skip_ci: ignore_skip_ci,
        save_incompleted: save_on_errors,
        seeds_block: block,
        variables_attributes: params[:variables_attributes],
        project: project,
        current_user: current_user,
        push_options: ::Ci::PipelineCreation::PushOptions.fabricate(params[:push_options]),
        chat_data: params[:chat_data],
        bridge: bridge,
        logger: @logger,
        partition_id: params[:partition_id],
        inputs: ::Feature.enabled?(:ci_inputs_for_pipelines, project) ? inputs : {},
        **extra_options(**)
      )

      Gitlab::Ci::Pipeline::Chain::Sequence.new(pipeline, command, SEQUENCE).build!
    ensure
      @logger.commit(pipeline: pipeline, caller: self.class.name)
      @command_logger.commit(pipeline: pipeline, command: command) if command
    end

    private

    def extra_options(content: nil, dry_run: false, linting: false)
      { content: content, dry_run: dry_run, linting: linting }
    end

    def build_logger
      Gitlab::Ci::Pipeline::Logger.new(project: project) do |l|
        l.log_when do |observations|
          observations.any? do |name, observation|
            name.to_s.end_with?('duration_s') &&
              Array(observation).max >= LOG_MAX_DURATION_THRESHOLD
          end
        end

        l.log_when do |observations|
          count = observations['pipeline_size_count']
          next false unless count

          count >= LOG_MAX_PIPELINE_SIZE
        end

        l.log_when do |observations|
          duration = observations['pipeline_creation_duration_s']
          next false unless duration

          duration >= LOG_MAX_CREATION_THRESHOLD
        end
      end
    end
  end
end
