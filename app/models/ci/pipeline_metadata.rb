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
  class PipelineMetadata < Ci::ApplicationRecord

    self.primary_key = :pipeline_id

    enum :auto_cancel_on_new_commit, {
      conservative: 0,
      interruptible: 1,
      none: 2
    }, prefix: true

    enum :auto_cancel_on_job_failure, {
      none: 0,
      all: 1
    }, prefix: true

    belongs_to :pipeline, class_name: "Ci::Pipeline", inverse_of: :pipeline_metadata
    belongs_to :project, class_name: "Project", inverse_of: :pipeline_metadata

    validates :pipeline, presence: true
    validates :project, presence: true
    validates :name, length: { minimum: 1, maximum: 255 }, allow_nil: true

  end
end

