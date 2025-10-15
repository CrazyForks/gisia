class CreateNamespaces < ActiveRecord::Migration[8.0]
  def change
    create_table :namespaces do |t|
      t.references :parent, index: false
      t.string :name, null: false
      t.string :path, null: false
      t.string :type, null: false
      t.integer :visibility_level, null: false, default: 0
      t.bigint :traversal_ids, array: true, null: false, default: []
      t.timestamps
      t.integer :creator_id

      t.index [:name, :parent_id, :type], unique: true
      t.index [:parent_id, :id], unique: true
      t.index :path
      t.index :type
      t.index :created_at
      t.index :traversal_ids, using: :gin
      t.index 'lower(name)'
      t.index 'lower(path)'
    end
  end
end
