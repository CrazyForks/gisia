class FixWorkItemsInternalIds < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    InternalId.where(usage: 71).find_each do |record|
      ActiveRecord::Base.transaction do
        namespace_id = record.namespace_id
        max_iid = WorkItem.where(namespace_id: namespace_id).maximum(:iid)

        InternalId.where(namespace_id: namespace_id).delete_all

        InternalId.create!(namespace_id: namespace_id, usage: 0, last_value: max_iid)
        InternalId.create!(namespace_id: namespace_id, usage: 4, last_value: max_iid)
      end
    end
  end

  def down
  end
end
