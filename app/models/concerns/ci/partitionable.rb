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
  module Partitionable
    extend ActiveSupport::Concern

    INITIAL_PARTITION_VALUE = 100

    def partition_id=(val)
      @partition_id = val
    end

    def partition_id
      @partition_id ||= INITIAL_PARTITION_VALUE
    end
  end
end
