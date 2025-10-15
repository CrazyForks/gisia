class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.integer :failed_attempts, default: 0, null: false
      t.string :unlock_token
      t.datetime :locked_at
      t.timestamps
      t.string :username, null: false
      t.string :name, null: false
      t.string :mobile
      t.string :avatar
      t.integer :user_type, default: 0
      t.boolean :admin, null: false, default: false
      t.boolean :composite_identity_enforced, null: false, default: false
      t.integer :state, default: 0, null: false
      t.boolean :password_automatically_set, default: false
      t.datetime :password_expires_at

      t.index :confirmation_token, unique: true
      t.index :email, unique: true
      t.index :mobile, unique: true
      t.index :reset_password_token, unique: true
      t.index :unlock_token, unique: true
      t.index :username, unique: true
      t.index :state
      t.index :user_type
    end

    add_index :users, 'lower(email)'
    add_index :users, 'lower(username)'
  end
end
