class CreateLabelWorkItems < ActiveRecord::Migration[8.0]
  def change
    create_table :label_work_items do |t|
      t.references :label, null: false, index: true
      t.references :work_item, null: false, index: true

      t.timestamps
    end
  end
end
