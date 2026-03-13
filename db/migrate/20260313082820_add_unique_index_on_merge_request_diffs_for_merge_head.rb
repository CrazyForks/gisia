class AddUniqueIndexOnMergeRequestDiffsForMergeHead < ActiveRecord::Migration[8.0]
  def change
    add_index :merge_request_diffs, :merge_request_id,
      unique: true,
      where: 'diff_type = 2',
      name: 'index_merge_request_diffs_on_unique_merge_request_id'
  end
end
