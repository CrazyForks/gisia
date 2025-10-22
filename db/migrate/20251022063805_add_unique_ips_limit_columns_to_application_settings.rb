class AddUniqueIpsLimitColumnsToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :unique_ips_limit_enabled, :boolean, null: false, default: false
    add_column :application_settings, :unique_ips_limit_per_user, :integer, default: 10
    add_column :application_settings, :unique_ips_limit_time_window, :integer, default: 3600
  end
end
