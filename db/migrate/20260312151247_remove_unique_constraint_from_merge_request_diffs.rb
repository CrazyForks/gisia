class RemoveUniqueConstraintFromMergeRequestDiffs < ActiveRecord::Migration[8.0]
  def change
    remove_index :merge_request_diffs, :merge_request_id, unique: true, name: :index_merge_request_diffs_on_merge_request_id
    add_index :merge_request_diffs, :merge_request_id, name: :index_merge_request_diffs_on_merge_request_id
  end
end
