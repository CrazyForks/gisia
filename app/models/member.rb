# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Member < ApplicationRecord
  include Accessible
  include Importable

  belongs_to :user
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :namespace

  scope :request, -> { where.not(requested_at: nil) }
  scope :non_request, -> { where(requested_at: nil) }

  def request?
    requested_at.present?
  end
end
