class CreateMergeRequestDiffCommits < ActiveRecord::Migration[8.0]
  def up
    create_table :merge_request_diff_commits, id: false do |t|
      t.bigint :id, null: false
      t.datetime :authored_date
      t.datetime :committed_date
      t.references :merge_request_diff, null: false, index: false
      t.integer :relative_order, null: false
      t.string :sha
      t.text :message
      t.jsonb :trailers, default: {}
      t.references :commit_author
      t.references :committer
      t.references :merge_request_commits_metadata, index: false

      t.index :sha
      t.index :merge_request_commits_metadata_id, where: 'merge_request_commits_metadata_id IS NOT NULL'
    end

    execute "CREATE SEQUENCE IF NOT EXISTS merge_request_diff_commits_id_seq"
    execute "ALTER TABLE merge_request_diff_commits ADD PRIMARY KEY (merge_request_diff_id, relative_order);"
  end

  def down
    drop_table :merge_request_diff_commits
  end
end
