class CreateProjectCiCdSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :project_ci_cd_settings do |t|
      t.references :project, null: false, index: false
      t.boolean :group_runners_enabled, null: false, default: true
      t.boolean :merge_pipelines_enabled
      t.integer :default_git_depth
      t.boolean :forward_deployment_enabled
      t.boolean :merge_trains_enabled, default: false
      t.boolean :auto_rollback_enabled, null: false, default: false
      t.boolean :keep_latest_artifact, null: false, default: true
      t.boolean :restrict_user_defined_variables, null: false, default: false
      t.boolean :job_token_scope_enabled, null: false, default: false
      t.integer :runner_token_expiration_interval
      t.boolean :separated_caches, null: false, default: true
      t.boolean :allow_fork_pipelines_to_run_in_parent_project, null: false, default: true
      t.boolean :inbound_job_token_scope_enabled, null: false, default: true
      t.boolean :forward_deployment_rollback_allowed, null: false, default: true
      t.boolean :merge_trains_skip_train_allowed, null: false, default: false
      t.integer :restrict_pipeline_cancellation_role, null: false, default: 0
      t.integer :pipeline_variables_minimum_override_role, null: false, default: 3
      t.boolean :push_repository_for_job_token_allowed, null: false, default: false
      t.string :id_token_sub_claim_components, array: true, null: false, default: ['project_path', 'ref_type', 'ref']
      t.integer :delete_pipelines_in_seconds
      t.boolean :allow_composite_identities_to_run_pipelines, null: false, default: false

      t.index :project_id, unique: true
      t.index :project_id, where: 'delete_pipelines_in_seconds IS NOT NULL', name: 'index_project_ci_cd_settings_on_project_id_partial'
    end
  end
end
