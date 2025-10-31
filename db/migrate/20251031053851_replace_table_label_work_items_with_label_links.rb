class ReplaceTableLabelWorkItemsWithLabelLinks < ActiveRecord::Migration[8.0]
  def change
    drop_table :label_work_items

    create_table :label_links do |t|
      t.references :label, null: false, foreign_key: true
      t.bigint :labelable_id, null: false
      t.string :labelable_type, null: false
      t.timestamps

      t.index [:label_id, :labelable_id, :labelable_type], unique: true
      t.index [:labelable_id, :labelable_type]
    end
  end
end
