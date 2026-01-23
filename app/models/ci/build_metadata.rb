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
  # The purpose of this class is to store Build related data that can be disposed.
  # Data that should be persisted forever, should be stored with Ci::Build model.
  class BuildMetadata < Ci::ApplicationRecord
    include Gitlab::Utils::StrongMemoize
    include ChronicDurationAttribute

    BuildTimeout = Struct.new(:value, :source)

    attr_accessor :partition_id

    self.table_name = 'ci_builds_metadata'
    enum :timeout_source, {
      unknown_timeout_source: 1,
      project_timeout_source: 2,
      runner_timeout_source: 3,
      job_timeout_source: 4
    }

    belongs_to :build
    belongs_to :project

    before_validation :set_build_project

    attribute :config_options, ::Gitlab::Database::Type::SymbolizedJsonb.new
    attribute :config_variables, ::Gitlab::Database::Type::SymbolizedJsonb.new

    chronic_duration_attr_reader :timeout_human_readable, :timeout

    def update_timeout_state
      timeout = timeout_with_highest_precedence

      return unless timeout

      update(timeout: timeout.value, timeout_source: timeout.source)
    end

    private

    def set_build_project
      self.project_id ||= build.project_id
    end

    def timeout_with_highest_precedence
      [job_timeout || project_timeout, runner_timeout].compact.min_by(&:value)
    end

    def project_timeout
      strong_memoize(:project_timeout) do
        BuildTimeout.new(project&.build_timeout, :project_timeout_source)
      end
    end

    def job_timeout
      return unless build.options

      strong_memoize(:job_timeout) do
        if timeout_from_options = build.options[:job_timeout]
          BuildTimeout.new(timeout_from_options, :job_timeout_source)
        end
      end
    end

    def runner_timeout
      return unless runner_timeout_set?

      strong_memoize(:runner_timeout) do
        BuildTimeout.new(build.runner.maximum_timeout, :runner_timeout_source)
      end
    end

    def runner_timeout_set?
      build.runner&.maximum_timeout.to_i > 0
    end
  end
end

