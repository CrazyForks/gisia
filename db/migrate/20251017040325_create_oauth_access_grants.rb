class CreateOauthAccessGrants < ActiveRecord::Migration[8.0]
  def change
    create_table :oauth_access_grants do |t|
      t.references :resource_owner, null: false, index: false
      t.references :application, null: false, index: true
      t.string :token, null: false
      t.integer :expires_in, null: false
      t.text :redirect_uri, null: false
      t.string :scopes, null: false, default: ''
      t.datetime :created_at, null: false
      t.datetime :revoked_at

      t.index :token, unique: true
      t.index [:created_at, :expires_in]
      t.index [:resource_owner_id, :application_id, :created_at]
    end
  end
end
