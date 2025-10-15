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
  class RunnerManagerBuild < Ci::ApplicationRecord
    attr_accessor :partition_id

    self.table_name = 'ci_runner_machine_builds'
    self.primary_key = :build_id

    alias_attribute :runner_manager_id, :runner_machine_id

    before_validation :ensure_project_id, on: :create

    belongs_to :build, inverse_of: :runner_manager_build, class_name: 'Ci::Build'
    belongs_to :runner_manager, foreign_key: :runner_machine_id, inverse_of: :runner_manager_builds,
      class_name: 'Ci::RunnerManager'

    validates :build, presence: true
    validates :runner_manager, presence: true
    validates :project_id, presence: true

    scope :for_build, ->(build_id) { where(build_id: build_id) }

    def self.pluck_build_id_and_runner_manager_id
      select(:build_id, :runner_manager_id)
        .pluck(:build_id, :runner_manager_id)
        .to_h
    end

    private

    def ensure_project_id
      self.project_id ||= build&.project_id
    end
  end
end
