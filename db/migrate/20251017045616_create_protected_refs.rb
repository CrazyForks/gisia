class CreateProtectedRefs < ActiveRecord::Migration[8.0]
  def change
    create_table :protected_refs do |t|
      t.string :type, null: false
      t.string :name, null: false
      t.timestamps
      t.integer :access_level, null: false, default: 30
      t.boolean :allow_push, null: false, default: false
      t.boolean :allow_force_push, null: false, default: false
      t.boolean :allow_merge_to, null: false, default: false
      t.references :namespace, null: false, index: false

      t.index :type
      t.index :namespace_id
      t.index [:namespace_id, :name, :type], unique: true
    end
  end
end
