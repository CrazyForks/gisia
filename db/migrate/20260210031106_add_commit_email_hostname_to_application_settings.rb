class AddCommitEmailHostnameToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :commit_email_hostname, :string
  end
end
