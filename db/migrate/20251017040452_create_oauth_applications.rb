class CreateOauthApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :oauth_applications do |t|
      t.string :name, null: false
      t.string :uid, null: false
      t.string :secret, null: false
      t.text :redirect_uri, null: false
      t.text :scopes, null: false, default: ''
      t.timestamps
      t.bigint :owner_id
      t.string :owner_type
      t.boolean :trusted, null: false, default: false
      t.boolean :confidential, null: false, default: true
      t.boolean :expire_access_tokens, null: false, default: false
      t.boolean :ropc_enabled, null: false, default: true
      t.boolean :dynamic, null: false, default: false

      t.index :uid, unique: true
      t.index [:owner_id, :owner_type]
    end
  end
end
