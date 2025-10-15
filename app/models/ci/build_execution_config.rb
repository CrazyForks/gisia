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
  class BuildExecutionConfig < Ci::ApplicationRecord
    self.table_name = :ci_builds_execution_configs
    self.primary_key = :id

    attr_accessor  :partition_id

    belongs_to :pipeline,
      class_name: 'Ci::Pipeline',
      inverse_of: :build_execution_configs

    belongs_to :project

    has_many :builds,
      class_name: 'Ci::Build',
      foreign_key: :execution_config_id,
      inverse_of: :execution_config

    validates :run_steps, json_schema: { filename: 'run_steps' }, presence: true
  end
end

