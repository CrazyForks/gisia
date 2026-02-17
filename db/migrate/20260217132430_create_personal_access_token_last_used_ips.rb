# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class CreatePersonalAccessTokenLastUsedIps < ActiveRecord::Migration[8.0]
  def change
    create_table :personal_access_token_last_used_ips do |t|
      t.references :personal_access_token, null: false
      t.timestamps
      t.inet :ip_address

      t.index :personal_access_token_id, name: 'idx_pat_last_used_ips_on_pat_id'
    end
  end
end
