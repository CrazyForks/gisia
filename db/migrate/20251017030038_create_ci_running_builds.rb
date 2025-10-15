class CreateCiRunningBuilds < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_running_builds do |t|
      t.references :build, null: false, index: false
      t.references :project, null: false, index: true
      t.references :runner, null: false, index: true
      t.integer :runner_type, null: false
      t.bigint :runner_owner_namespace_xid
      t.datetime :created_at, null: false, default: -> { 'now()' }

      t.index :build_id, unique: true
      t.index [:runner_type, :runner_owner_namespace_xid, :runner_id]
    end
  end
end
