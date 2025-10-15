# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class NamespaceSetting < ApplicationRecord
  belongs_to :namespace, inverse_of: :namespace_settings

  validates :default_branch_name, length: { maximum: 255 }

  NAMESPACE_SETTINGS_PARAMS = %i[
    default_branch_name
  ].freeze

  def self.allowed_namespace_settings_params
    NAMESPACE_SETTINGS_PARAMS
  end
end
