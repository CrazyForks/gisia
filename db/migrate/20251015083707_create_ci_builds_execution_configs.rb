class CreateCiBuildsExecutionConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_builds_execution_configs do |t|
      t.references :project, null: false, index: true
      t.references :pipeline, null: false, index: true
      t.jsonb :run_steps, null: false, default: {}
    end
  end
end
