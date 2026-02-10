# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class WebHook < ApplicationRecord
  include Gitlab::EncryptedAttribute

  MAX_PARAM_LENGTH = 8192

  belongs_to :namespace

  attr_encrypted :url,
    mode: :per_attribute_iv,
    algorithm: 'aes-256-gcm',
    key: :db_key_base_32

  validates :url, presence: true
  validates :url, length: { maximum: MAX_PARAM_LENGTH }

  validates :name, length: { maximum: 255 }
  validates :description, length: { maximum: 2048 }
end

