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
  class CancelRedundantPipelinesJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Ci::Pipeline.find_by_id(pipeline_id).try do |pipeline|
        Ci::PipelineCreation::CancelRedundantPipelinesService.new(pipeline).execute
      end
    end
  end
end
