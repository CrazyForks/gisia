class AddUniqueIndexOnPathAndParentIdAndTypeToNamespaces < ActiveRecord::Migration[8.0]
  def change
    add_index :namespaces, [:path, :parent_id, :type], unique: true, name: 'index_namespaces_on_path_and_parent_id_and_type'
  end
end
