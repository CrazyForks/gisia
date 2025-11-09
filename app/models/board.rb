# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Board < ApplicationRecord
  belongs_to :namespace
  belongs_to :updated_by, class_name: 'User'
  has_one :project, through: :namespace
  has_many :stages, class_name: 'BoardStage', dependent: :destroy
end

