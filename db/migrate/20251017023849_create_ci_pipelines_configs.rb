class CreateCiPipelinesConfigs < ActiveRecord::Migration[8.0]
  def up
    create_table :ci_pipelines_configs, id: false do |t|
      t.bigint :pipeline_id, null: false
      t.text :content, null: false
      t.bigint :project_id, null: false
      t.timestamps
    end

    execute "ALTER TABLE ci_pipelines_configs ADD PRIMARY KEY (pipeline_id);"
  end

  def down
    drop_table :ci_pipelines_configs
  end
end
