class CreateNamespaceSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :namespace_settings do |t|
      t.references :namespace, null: false, index: false
      t.text :default_branch_name
      t.timestamps

      t.index :namespace_id, unique: true
    end
  end
end
