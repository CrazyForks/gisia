class UpdateWorkItemsUniqueConstraint < ActiveRecord::Migration[8.0]
  def change
    remove_index :work_items, name: "index_work_items_on_namespace_id_and_iid"
    add_index :work_items, [:namespace_id, :type, :iid], unique: true, name: "index_work_items_on_namespace_id_and_type_and_iid"
  end
end

