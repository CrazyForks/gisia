class CreateCiRunners < ActiveRecord::Migration[8.0]
  def up
    create_table :ci_runners do |t|
      t.references :creator
      t.datetime :contacted_at
      t.datetime :token_expires_at
      t.integer :access_level, null: false, default: 0
      t.integer :maximum_timeout
      t.integer :runner_type, null: false
      t.integer :registration_type, null: false, default: 0
      t.integer :creation_state, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.boolean :run_untagged, null: false, default: true
      t.boolean :locked, null: false, default: false
      t.text :name
      t.text :token_encrypted
      t.text :token
      t.text :description
      t.text :maintainer_note
      t.timestamps
      t.references :sharding_key

      t.index [:runner_type]
      t.index [:active, :id]
      t.index [:contacted_at, :id]
      t.index :locked
      t.index [:token_expires_at, :id]
      t.index [:token, :runner_type], unique: true, where: 'token IS NOT NULL'
    end
  end

  def down
    drop_table :ci_runners
  end
end
