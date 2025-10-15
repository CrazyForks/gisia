class CreateCiPipelineMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_pipeline_messages do |t|
      t.integer :severity, limit: 2, null: false, default: 0
      t.text :content, null: false
      t.references :pipeline, null: false, index: true
      t.references :project, index: true
      t.timestamps
    end
  end
end
