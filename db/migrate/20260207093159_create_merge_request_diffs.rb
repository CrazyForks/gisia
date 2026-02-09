# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class CreateMergeRequestDiffs < ActiveRecord::Migration[8.0]
  def change
    create_table :merge_request_diffs do |t|
      t.string  :state, null: true
      t.bigint  :merge_request_id, null: false
      t.string :base_commit_sha, null: true
      t.string :real_size, null: true
      t.string :head_commit_sha, null: true
      t.string :start_commit_sha, null: true
      t.integer :commits_count, default: 0, null: true
      t.string  :external_diff, null: true
      t.integer :external_diff_store, default: 1, null: true
      t.boolean :stored_externally, null: true
      t.integer :files_count, limit: 2, default: 0, null: true
      t.boolean :sorted, default: false, null: false
      t.integer :diff_type, limit: 2, default: 1, null: false
      t.binary :patch_id_sha, null: true
      t.bigint :project_id, null: false

      t.timestamps
    end

    add_index :merge_request_diffs, :external_diff
    add_index :merge_request_diffs, :external_diff_store
    add_index :merge_request_diffs, :merge_request_id, unique: true
    add_index :merge_request_diffs, :project_id
    add_index :merge_request_diffs, :head_commit_sha
  end
end
