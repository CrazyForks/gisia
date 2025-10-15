class CreateCiRunnerMachineBuilds < ActiveRecord::Migration[8.0]
  def up
    create_table :ci_runner_machine_builds, id: false do |t|
      t.bigint :build_id, null: false
      t.bigint :runner_machine_id, null: false
      t.bigint :project_id

      t.index :project_id
      t.index :runner_machine_id
    end

    execute "ALTER TABLE ci_runner_machine_builds ADD PRIMARY KEY (build_id);"
  end

  def down
    drop_table :ci_runner_machine_builds
  end
end
