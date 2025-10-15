class CreateCiPipelineMetadata < ActiveRecord::Migration[8.0]
  def up
    create_table :ci_pipeline_metadata, id: false do |t|
      t.references :project, null: false, index: true
      t.references :pipeline, null: false, index: false
      t.text :name
      t.integer :auto_cancel_on_new_commit, null: false, default: 0
      t.integer :auto_cancel_on_job_failure, null: false, default: 0
    end

    execute "ALTER TABLE ci_pipeline_metadata ADD PRIMARY KEY (pipeline_id);"
  end

  def down
    drop_table :ci_pipeline_metadata
  end
end
