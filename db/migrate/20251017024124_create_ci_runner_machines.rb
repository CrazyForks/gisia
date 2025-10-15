class CreateCiRunnerMachines < ActiveRecord::Migration[8.0]
  def up
    create_table :ci_runner_machines, id: false do |t|
      t.bigint :id, null: false
      t.references :runner, null: false, index: false
      t.references :sharding_key
      t.datetime :contacted_at
      t.integer :creation_state, null: false, default: 0
      t.integer :executor_type
      t.integer :runner_type, null: false
      t.jsonb :config, null: false, default: {}
      t.text :system_xid, null: false
      t.text :platform
      t.text :architecture
      t.text :revision
      t.text :ip_address
      t.text :version
      t.jsonb :runtime_features, null: false, default: {}
      t.timestamps

      t.index :version
      t.index :executor_type
      t.index :ip_address
      t.index [:runner_id, :runner_type, :system_xid], unique: true
      t.index [:contacted_at, :id]
      t.index [:created_at, :id]
    end

    execute "CREATE SEQUENCE IF NOT EXISTS ci_runner_machines_id_seq"
    execute "ALTER TABLE ci_runner_machines ADD PRIMARY KEY (id, runner_type);"
  end

  def down
    drop_table :ci_runner_machines
  end
end
