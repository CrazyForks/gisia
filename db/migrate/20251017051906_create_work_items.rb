class CreateWorkItems < ActiveRecord::Migration[8.0]
  def change
    create_table :work_items do |t|
      t.string :type, null: false
      t.string :title
      t.references :author, type: :bigint
      t.text :description
      t.integer :iid
      t.references :updated_by, type: :bigint
      t.boolean :confidential, null: false, default: false
      t.date :due_date
      t.integer :state_id, limit: 2, null: false, default: 1
      t.timestamp :closed_at
      t.references :closed_by, type: :bigint
      t.references :parent, type: :bigint
      t.references :namespace, type: :bigint

      t.timestamps
    end

    add_index :work_items, :type
    add_index :work_items, [:namespace_id, :iid], unique: true
    add_index :work_items, :state_id
  end
end

