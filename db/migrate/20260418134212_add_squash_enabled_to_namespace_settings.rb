class AddSquashEnabledToNamespaceSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :namespace_settings, :squash_enabled, :boolean, null: false, default: false
  end
end
