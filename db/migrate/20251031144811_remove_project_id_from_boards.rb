class RemoveProjectIdFromBoards < ActiveRecord::Migration[8.0]
  def change
    remove_index :boards, :project_id
    remove_column :boards, :project_id, :bigint
  end
end
