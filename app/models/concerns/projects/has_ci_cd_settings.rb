# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Projects
  module HasCiCdSettings
    extend ActiveSupport::Concern

    included do
      has_one :ci_cd_settings, class_name: 'ProjectCiCdSetting', inverse_of: :project, autosave: true,
        dependent: :destroy

      after_create -> { create_or_load_association(:ci_cd_settings) }

      accepts_nested_attributes_for :ci_cd_settings, update_only: true

      with_options to: :ci_cd_settings, allow_nil: true do
        delegate :allow_composite_identities_to_run_pipelines, :allow_composite_identities_to_run_pipelines=
        delegate :group_runners_enabled, :group_runners_enabled=
        delegate :keep_latest_artifact, :keep_latest_artifact=
        delegate :restrict_user_defined_variables, :restrict_user_defined_variables=
        delegate :runner_token_expiration_interval, :runner_token_expiration_interval=,
          :runner_token_expiration_interval_human_readable, :runner_token_expiration_interval_human_readable=
        delegate :job_token_scope_enabled, :job_token_scope_enabled=, prefix: :ci_outbound

        with_options prefix: :ci do
          delegate :pipeline_variables_minimum_override_role, :pipeline_variables_minimum_override_role=
          delegate :push_repository_for_job_token_allowed, :push_repository_for_job_token_allowed=
          delegate :default_git_depth, :default_git_depth=
          delegate :forward_deployment_enabled, :forward_deployment_enabled=
          delegate :forward_deployment_rollback_allowed, :forward_deployment_rollback_allowed=
          delegate :inbound_job_token_scope_enabled, :inbound_job_token_scope_enabled=
          delegate :allow_fork_pipelines_to_run_in_parent_project, :allow_fork_pipelines_to_run_in_parent_project=
          delegate :separated_caches, :separated_caches=
          delegate :id_token_sub_claim_components, :id_token_sub_claim_components=
          delegate :delete_pipelines_in_seconds, :delete_pipelines_in_seconds=
        end
      end
    end
  end
end
