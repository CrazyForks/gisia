# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class CreateFieldsToMergeRequestMetrics < ActiveRecord::Migration[8.0]
  def change
    create_table :merge_request_metrics do |t|
      t.bigint :merge_request_id, null: false

      t.timestamp :latest_build_started_at
      t.timestamp :latest_build_finished_at
      t.timestamp :first_deployed_to_production_at
      t.timestamp :merged_at

      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false

      t.bigint :merged_by_id
      t.bigint :latest_closed_by_id

      t.column :latest_closed_at, :timestamptz
      t.column :first_comment_at, :timestamptz
      t.column :first_commit_at, :timestamptz
      t.column :last_commit_at, :timestamptz

      t.integer :diff_size
      t.integer :modified_paths_size
      t.integer :commits_count

      t.column :first_approved_at, :timestamptz
      t.column :first_reassigned_at, :timestamptz

      t.integer :added_lines
      t.integer :removed_lines

      t.bigint :target_project_id
      t.bigint :pipeline_id

      t.boolean :first_contribution, null: false, default: false

      t.column :reviewer_first_assigned_at, :timestamptz
    end

    add_index :merge_request_metrics, :merge_request_id, unique: true
    add_index :merge_request_metrics, :merged_at
    add_index :merge_request_metrics, :pipeline_id
  end
end
