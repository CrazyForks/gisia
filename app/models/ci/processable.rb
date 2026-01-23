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
  # This class is a collection of common features between Ci::Build and Ci::Bridge.
  # In https://gitlab.com/groups/gitlab-org/-/epics/9991, we aim to clarify class naming conventions.
  class Processable < ::CommitStatus
    include Gitlab::Utils::StrongMemoize
    include FromUnion
    include Ci::Metadatable
    include Ci::Builds::Processable

    extend ::Gitlab::Utils::Override

    ACTIONABLE_WHEN = %w[manual delayed].freeze

    has_one :trigger, through: :pipeline
    has_one :sourced_pipeline, class_name: 'Ci::Sources::Pipeline', foreign_key: :source_job_id, inverse_of: :source_job

    accepts_nested_attributes_for :needs

    validates :type, presence: true
    validates :scheduling_type, presence: true, on: :create, unless: :importing?

    delegate :merge_request?,
      :merge_request_ref?,
      :legacy_detached_merge_request_pipeline?,
      :merge_train_pipeline?,
      to: :pipeline

    delegate :short_token, to: :trigger, prefix: true, allow_nil: true

    state_machine :status do
      after_transition any => [:failed] do |processable|
        next if processable.allow_failure?
        next unless processable.can_auto_cancel_pipeline_on_job_failure?

        processable.run_after_commit do
          processable.pipeline.cancel_async_on_job_failure
        end
      end
    end

    def can_auto_cancel_pipeline_on_job_failure?
      raise NotImplementedError
    end

    def self.select_with_aggregated_needs(_project)
      aggregated_needs_names = Ci::BuildNeed
                               .scoped_build
                               .select('ARRAY_AGG(name)')
                               .to_sql

      all.select(
        '*',
        "(#{aggregated_needs_names}) as aggregated_needs_names"
      )
    end

    def all_dependencies
      strong_memoize(:all_dependencies) do
        dependencies.all
      end
    end

    def retryable?
      return false if retried?

      success? || failed? || canceled? || canceling?
    end

    # Todo,
    def expanded_environment_name
      # raise NotImplementedError
    end

    def dependency_variables
      []
    end

    private

    def dependencies
      strong_memoize(:dependencies) do
        Ci::BuildDependencies.new(self)
      end
    end
  end
end
