class CreateCiPipelines < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_pipelines do |t|
      t.string :ref, null: false
      t.string :sha, null: false
      t.text :yaml_errors
      t.references :project, null: false, index: false
      t.string :status
      t.datetime :finished_at
      t.integer :duration
      t.integer :failure_reason
      t.references :merge_request
      t.references :trigger
      t.timestamps
      t.integer :source, null: false, default: 0
      t.string :before_sha
      t.string :target_sha
      t.string :source_sha
      t.references :user, null: false, index: false
      t.boolean :tag, null: false, default: false
      t.integer :iid, null: false
      t.integer :config_source
      t.integer :locked, null: false, default: 1
      t.datetime :started_at
      t.boolean :protected, null: false, default: false
      t.references :pipeline_schedule
      t.references :auto_canceled_by
      t.datetime :committed_at
      t.references :ci_ref, null: false, index: true

      t.index [:project_id, :id]
      t.index [:project_id, :iid], unique: true, where: 'iid IS NOT NULL'
      t.index [:project_id, :ref]
      t.index [:project_id, :sha]
      t.index [:project_id, :status]
      t.index [:status, :id]
      t.index :user_id
    end
  end
end
