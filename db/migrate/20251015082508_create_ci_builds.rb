class CreateCiBuilds < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_builds do |t|
      t.integer :status, null: false, default: 0
      t.datetime :finished_at
      t.datetime :started_at
      t.string :name, null: false
      t.boolean :allow_failure, null: false, default: false
      t.integer :stage_idx, null: false
      t.string :ref, null: false
      t.datetime :artifacts_expire_at
      t.text :yaml_variables
      t.datetime :queued_at
      t.boolean :retried, null: false, default: false
      t.integer :failure_reason
      t.datetime :scheduled_at
      t.bigint :stage_id, null: false
      t.bigint :commit_id, null: false
      t.bigint :project_id, null: false
      t.bigint :runner_id
      t.bigint :upstream_pipeline_id
      t.bigint :user_id, null: false
      t.string :when
      t.integer :scheduling_type
      t.boolean :tag
      t.boolean :protected
      t.jsonb :options
      t.float :coverage
      t.string :target_url
      t.datetime :erased_at
      t.string :environment
      t.string :coverage_regex
      t.string :token_encrypted
      t.bigint :resource_group_id
      t.datetime :waiting_for_resource_at
      t.boolean :processed, default: false
      t.bigint :auto_canceled_by_id
      t.bigint :erased_by_id
      t.bigint :trigger_request_id
      t.bigint :execution_config_id
      t.string :description
      t.timestamps
      t.integer :lock_version, default: 0
      t.integer :type, null: false, default: 0
      t.integer :exit_code

      t.index :commit_id
      t.index :project_id
      t.index :runner_id
      t.index :user_id
      t.index :stage_id
      t.index :status
      t.index [:commit_id, :status, :type]
      t.index [:project_id, :status]
      t.index [:token_encrypted], unique: true, where: 'token_encrypted IS NOT NULL'
    end
  end
end
