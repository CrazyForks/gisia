class FixCiRunnerMachinesIdPrimaryKey < ActiveRecord::Migration[8.0]
  def up
    execute "ALTER TABLE ci_runner_machines DROP CONSTRAINT IF EXISTS ci_runner_machines_pkey"
    execute "DROP SEQUENCE IF EXISTS ci_runner_machines_id_seq"
    execute "CREATE SEQUENCE ci_runner_machines_id_seq"
    execute "ALTER TABLE ci_runner_machines ALTER COLUMN id SET DEFAULT nextval('ci_runner_machines_id_seq'::regclass)"
    execute "SELECT setval('ci_runner_machines_id_seq', (SELECT MAX(id) FROM ci_runner_machines))"
    execute "ALTER TABLE ci_runner_machines ADD PRIMARY KEY (id)"
  end
end
