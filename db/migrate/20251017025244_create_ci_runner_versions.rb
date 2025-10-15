class CreateCiRunnerVersions < ActiveRecord::Migration[8.0]
  def up
    create_table :ci_runner_versions, id: false do |t|
      t.text :version, null: false
      t.integer :status
    end

    execute "ALTER TABLE ci_runner_versions ADD PRIMARY KEY (version);"
    add_index :ci_runner_versions, [:status, :version], unique: true
  end

  def down
    drop_table :ci_runner_versions
  end
end
