class CreateCiTriggers < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_triggers do |t|
      t.string :token, null: false
      t.references :project, null: false, index: false
      t.references :owner, null: false, index: true
      t.string :description
      t.binary :encrypted_token
      t.binary :encrypted_token_iv
      t.datetime :expires_at
      t.timestamps

      t.index [:project_id, :id]
      t.index :token, unique: true
      t.index :encrypted_token, unique: true
    end
  end
end
