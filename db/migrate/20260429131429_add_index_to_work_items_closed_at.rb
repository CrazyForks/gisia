class AddIndexToWorkItemsClosedAt < ActiveRecord::Migration[8.0]
  def change
    add_index :work_items, :closed_at
  end
end
