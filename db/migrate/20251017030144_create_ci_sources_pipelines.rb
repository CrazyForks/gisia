class CreateCiSourcesPipelines < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_sources_pipelines do |t|
      t.references :project, index: true
      t.references :source_project, index: true
      t.references :source_job, index: true
      t.references :pipeline, index: true
      t.references :source_pipeline, index: true
    end
  end
end
