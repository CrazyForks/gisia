# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class CreatePersonalAccessTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :personal_access_tokens do |t|
      t.references :user, null: false, index: true
      t.string :name, null: false
      t.boolean :revoked, default: false
      t.date :expires_at
      t.string :scopes, null: false, default: '--- []\n'
      t.boolean :impersonation, default: false, null: false
      t.string :token_digest
      t.datetime :last_used_at
      t.text :description
      t.timestamps

      t.index :token_digest, unique: true, name: 'idx_pat_on_token_digest'
      t.index [:user_id, :expires_at], name: 'idx_pat_on_user_id_and_expires_at'
      t.index [:user_id, :last_used_at, :id], name: 'idx_pat_on_user_id_and_last_used_at'
      t.index [:user_id, :created_at, :id],
        where: 'impersonation = false',
        name: 'idx_pat_on_user_id_created_at_no_impersonation'
    end
  end
end
