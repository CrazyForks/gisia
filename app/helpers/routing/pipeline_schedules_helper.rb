# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Routing
  module PipelineSchedulesHelper
    def pipeline_schedules_path(project, *args)
      project_pipeline_schedules_path(project, *args)
    end

    def pipeline_schedule_path(schedule, *args)
      project = schedule.project
      project_pipeline_schedule_path(project, schedule, *args)
    end

    def edit_pipeline_schedule_path(schedule)
      project = schedule.project
      edit_project_pipeline_schedule_path(project, schedule)
    end

    def play_pipeline_schedule_path(schedule, *args)
      project = schedule.project
      play_project_pipeline_schedule_path(project, schedule, *args)
    end

    def take_ownership_pipeline_schedule_path(schedule, *args)
      project = schedule.project
      take_ownership_project_pipeline_schedule_path(project, schedule, *args)
    end
  end
end
