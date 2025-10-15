# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Enums
  module InternalId
    def self.usage_resources
      # when adding new resource, make sure it doesn't conflict with EE usage_resources
      {
        issues: 0,
        merge_requests: 1,
        deployments: 2,
        milestones: 3,
        epics: 4,
        ci_pipelines: 5,
        operations_feature_flags: 6,
        operations_user_lists: 7,
        alert_management_alerts: 8,
        sprints: 9, # iterations
        design_management_designs: 10,
        incident_management_oncall_schedules: 11,
        ml_experiments: 12,
        ml_candidates: 13,
        # Todo,
        work_items: 71
      }
    end
  end
end

Enums::InternalId.prepend_mod_with('Enums::InternalId')
