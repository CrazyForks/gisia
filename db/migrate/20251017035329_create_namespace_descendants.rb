class CreateNamespaceDescendants < ActiveRecord::Migration[8.0]
  def up
    create_table :namespace_descendants, id: false do |t|
      t.bigint :namespace_id, null: false, default: 0
      t.bigint :self_and_descendant_group_ids, array: true, null: false, default: []
      t.bigint :all_project_ids, array: true, null: false, default: []
      t.bigint :traversal_ids, array: true, null: false, default: []
      t.column :outdated_at, :timestamptz
      t.column :calculated_at, :timestamptz
      t.bigint :all_active_project_ids, array: true, null: false, default: []
      t.bigint :all_unarchived_project_ids, array: true, default: []

      t.index :namespace_id, where: 'outdated_at IS NOT NULL'
    end

    execute "ALTER TABLE namespace_descendants ADD PRIMARY KEY (namespace_id);"
  end

  def down
    drop_table :namespace_descendants
  end
end
