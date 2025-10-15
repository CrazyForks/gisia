# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Organizations
  class Organization < ApplicationRecord
    DEFAULT_ORGANIZATION_ID = 1
    scope :without_default, -> { where.not(id: DEFAULT_ORGANIZATION_ID) }
  end
end
