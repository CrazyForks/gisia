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
  class PipelineConfig < Ci::ApplicationRecord
    self.table_name = 'ci_pipelines_configs'
    self.primary_key = :pipeline_id

    belongs_to :pipeline, class_name: "Ci::Pipeline", inverse_of: :pipeline_config
    validates :pipeline, presence: true
    validates :content, presence: true
    validates :project_id, presence: true
  end
end

