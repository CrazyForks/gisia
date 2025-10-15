class CreateMergeRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :merge_requests do |t|
      t.references :target_project, null: false, index: false
      t.string :target_branch, null: false
      t.string :source_branch, null: false
      t.references :source_project, null: false, index: true
      t.references :author, null: false, index: false
      t.string :title, null: false
      t.text :description
      t.text :merge_error
      t.jsonb :merge_params, null: false, default: {}
      t.references :merge_user
      t.integer :status, null: false, default: 1
      t.string :merge_ref_sha
      t.timestamps
      t.references :latest_merge_request_diff
      t.integer :iid
      t.boolean :draft, null: false, default: false
      t.references :head_pipeline
      t.string :merge_commit_sha
      t.string :merge_jid
      t.string :merge_status, null: false, default: 'unchecked'
      t.boolean :merge_when_pipeline_succeeds, null: false, default: false
      t.binary :merged_commit_sha
      t.boolean :override_requested_changes, null: false, default: false
      t.column :prepared_at, :timestamptz
      t.string :rebase_commit_sha
      t.string :rebase_jid
      t.boolean :retargeted, null: false, default: false
      t.boolean :squash, null: false, default: false
      t.binary :squash_commit_sha
      t.integer :state_id, limit: 2, null: false, default: 1
      t.string :in_progress_merge_commit_sha

      t.index [:target_project_id, :iid], unique: true
      t.index :target_project_id
      t.index :target_branch
      t.index :source_branch
      t.index :author_id
      t.index [:author_id, :created_at]
      t.index :created_at
      t.index [:target_project_id, :source_branch]
      t.index [:source_project_id, :source_branch]
      t.index [:target_project_id, :merged_commit_sha]
      t.index [:target_project_id, :squash_commit_sha]
    end
  end
end
