# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class PersonalAccessTokenLastUsedIp < ApplicationRecord
  NUM_IPS_TO_STORE = 5

  belongs_to :personal_access_token

  def self.track!(personal_access_token, ip_address)
    return unless ip_address.present?
    return if where(personal_access_token: personal_access_token, ip_address: ip_address).exists?

    create!(personal_access_token: personal_access_token, ip_address: ip_address)
    cleanup_old_records!(personal_access_token)
  end

  def self.cleanup_old_records!(personal_access_token)
    count = where(personal_access_token: personal_access_token).count
    return unless count > NUM_IPS_TO_STORE

    where(personal_access_token: personal_access_token)
      .order(created_at: :asc)
      .limit(count - NUM_IPS_TO_STORE)
      .delete_all
  end
end
