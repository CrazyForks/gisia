class RenameOrganizationIdToNamespaceIdInLabels < ActiveRecord::Migration[8.0]
  def change
    remove_column :labels, :organization_id
    add_column :labels, :namespace_id, :bigint
    add_index :labels, :namespace_id
  end
end
