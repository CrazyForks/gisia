class AddEncryptedCiKeysToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :encrypted_ci_job_token_signing_key, :binary
    add_column :application_settings, :encrypted_ci_job_token_signing_key_iv, :binary
    add_column :application_settings, :encrypted_ci_jwt_signing_key, :text
    add_column :application_settings, :encrypted_ci_jwt_signing_key_iv, :text
  end
end
