# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Gitlab
  module PerformanceBar
    ALLOWED_USER_IDS_KEY = 'performance_bar_allowed_user_ids:v2'
    EXPIRY_TIME_L1_CACHE = 1.minute
    EXPIRY_TIME_L2_CACHE = 5.minutes

    def self.enabled_for_request?
      false
    end
  end
end
