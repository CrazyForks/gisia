class RemoveIdFromMergeRequestDiffFiles < ActiveRecord::Migration[8.0]
  def up
    remove_column :merge_request_diff_files, :id
    execute "DROP SEQUENCE IF EXISTS merge_request_diff_files_id_seq"
  end

  def down
    add_column :merge_request_diff_files, :id, :bigint, null: false
    execute "CREATE SEQUENCE IF NOT EXISTS merge_request_diff_files_id_seq"
  end
end
