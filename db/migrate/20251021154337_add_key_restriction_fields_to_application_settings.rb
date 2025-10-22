class AddKeyRestrictionFieldsToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :rsa_key_restriction, :integer, default: 0, null: false
    add_column :application_settings, :dsa_key_restriction, :integer, default: 0, null: false
    add_column :application_settings, :ecdsa_key_restriction, :integer, default: 0, null: false
    add_column :application_settings, :ecdsa_sk_key_restriction, :integer, default: 0, null: false
    add_column :application_settings, :ed25519_key_restriction, :integer, default: 0, null: false
    add_column :application_settings, :ed25519_sk_key_restriction, :integer, default: 0, null: false
  end
end
