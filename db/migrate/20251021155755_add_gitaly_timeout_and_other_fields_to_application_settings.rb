class AddGitalyTimeoutAndOtherFieldsToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :gitaly_timeout_default, :integer, default: 55, null: false
    add_column :application_settings, :gitaly_timeout_fast, :integer, default: 10, null: false
    add_column :application_settings, :gitaly_timeout_medium, :integer, default: 30, null: false
    add_column :application_settings, :plantuml_enabled, :boolean, default: false, null: false
    add_column :application_settings, :plantuml_url, :string
    add_column :application_settings, :ci_max_includes, :integer, default: 150, null: false
    add_column :application_settings, :ci_max_total_yaml_size_bytes, :integer, default: 314572800, null: false
    add_column :application_settings, :personal_access_token_prefix, :text, default: 'glpat-'
    add_column :application_settings, :repository_storages_weighted, :jsonb, default: {}, null: false
  end
end
