# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module HasPlan
  extend ActiveSupport::Concern

  def actual_plan
    Plan.default
  end

  def actual_limits
    # We default to PlanLimits.new otherwise a lot of specs would fail
    # On production each plan should already have associated limits record
    # https://gitlab.com/gitlab-org/gitlab/issues/36037
    actual_plan.actual_limits
  end

  def actual_plan_name
    actual_plan.name
  end
end
