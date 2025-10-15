class CreateProjectPipelineSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :project_pipeline_settings do |t|
      t.boolean :auto_cancel_pending_pipelines, default: true
      t.string :ci_config_path
      t.boolean :build_allow_git_fetch, default: true
      t.integer :build_timeout, default: 3600
      t.references :project, null: false, index: true
      t.timestamps
    end
  end
end
