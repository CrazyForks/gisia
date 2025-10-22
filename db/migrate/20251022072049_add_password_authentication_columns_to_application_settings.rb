class AddPasswordAuthenticationColumnsToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :password_authentication_enabled_for_git, :boolean, null: false, default: true
    add_column :application_settings, :password_authentication_enabled_for_web, :boolean
  end
end
