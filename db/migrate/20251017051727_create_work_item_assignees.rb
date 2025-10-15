class CreateWorkItemAssignees < ActiveRecord::Migration[8.0]
  def change
    create_table :work_item_assignees do |t|
      t.references :work_item, null: false
      t.references :assignee, null: false
      t.timestamps

      t.index [:work_item_id, :assignee_id], unique: true
    end
  end
end
