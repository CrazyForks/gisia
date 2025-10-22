class AddMaxYamlColumnsToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :max_yaml_depth, :integer, null: false, default: 100
    add_column :application_settings, :max_yaml_size_bytes, :bigint, null: false, default: 2097152
  end
end
