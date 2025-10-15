class CreateOauthAccessTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :oauth_access_tokens do |t|
      t.references :resource_owner, index: false
      t.references :application, null: false, index: true
      t.string :token, null: false
      t.string :refresh_token
      t.integer :expires_in
      t.string :scopes
      t.datetime :created_at, null: false
      t.datetime :revoked_at
      t.string :previous_refresh_token, null: false, default: ''

      t.index :token, unique: true
      t.index :refresh_token, unique: true
      t.index [:resource_owner_id, :application_id, :created_at], where: 'revoked_at IS NULL'
    end
  end
end
