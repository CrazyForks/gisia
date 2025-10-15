class CreatePlanLimits < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_limits do |t|
      t.references :plan, null: false, index: false

      t.integer :ci_pipeline_size, null: false, default: 0
      t.integer :ci_active_jobs, null: false, default: 0
      t.integer :project_hooks, null: false, default: 100
      t.integer :group_hooks, null: false, default: 50
      t.integer :ci_project_subscriptions, null: false, default: 2
      t.integer :ci_pipeline_schedules, null: false, default: 10
      t.integer :offset_pagination_limit, null: false, default: 50000
      t.integer :ci_instance_level_variables, null: false, default: 25
      t.integer :storage_size_limit, null: false, default: 0
      t.integer :ci_max_artifact_size_lsif, null: false, default: 200
      t.integer :ci_max_artifact_size_archive, null: false, default: 0
      t.integer :ci_max_artifact_size_metadata, null: false, default: 0
      t.integer :ci_max_artifact_size_trace, null: false, default: 0
      t.integer :ci_max_artifact_size_junit, null: false, default: 0
      t.integer :ci_max_artifact_size_sast, null: false, default: 0
      t.integer :ci_max_artifact_size_dependency_scanning, null: false, default: 350
      t.integer :ci_max_artifact_size_container_scanning, null: false, default: 150
      t.integer :ci_max_artifact_size_dast, null: false, default: 0
      t.integer :ci_max_artifact_size_codequality, null: false, default: 0
      t.integer :ci_max_artifact_size_license_management, null: false, default: 0
      t.integer :ci_max_artifact_size_license_scanning, null: false, default: 100
      t.integer :ci_max_artifact_size_performance, null: false, default: 0
      t.integer :ci_max_artifact_size_metrics, null: false, default: 0
      t.integer :ci_max_artifact_size_metrics_referee, null: false, default: 0
      t.integer :ci_max_artifact_size_network_referee, null: false, default: 0
      t.integer :ci_max_artifact_size_dotenv, null: false, default: 0
      t.integer :ci_max_artifact_size_cobertura, null: false, default: 0
      t.integer :ci_max_artifact_size_terraform, null: false, default: 5
      t.integer :ci_max_artifact_size_accessibility, null: false, default: 0
      t.integer :ci_max_artifact_size_cluster_applications, null: false, default: 0
      t.integer :ci_max_artifact_size_secret_detection, null: false, default: 0
      t.integer :ci_max_artifact_size_requirements, null: false, default: 0
      t.integer :ci_max_artifact_size_coverage_fuzzing, null: false, default: 0
      t.integer :ci_max_artifact_size_browser_performance, null: false, default: 0
      t.integer :ci_max_artifact_size_load_performance, null: false, default: 0
      t.integer :ci_needs_size_limit, null: false, default: 50
      t.bigint :conan_max_file_size, null: false, default: 3221225472
      t.bigint :maven_max_file_size, null: false, default: 3221225472
      t.bigint :npm_max_file_size, null: false, default: 524288000
      t.bigint :nuget_max_file_size, null: false, default: 524288000
      t.bigint :pypi_max_file_size, null: false, default: 3221225472
      t.bigint :generic_packages_max_file_size, null: false, default: 5368709120
      t.bigint :golang_max_file_size, null: false, default: 104857600
      t.bigint :debian_max_file_size, null: false, default: 3221225472
      t.integer :project_feature_flags, null: false, default: 200
      t.integer :ci_max_artifact_size_api_fuzzing, null: false, default: 0
      t.integer :ci_pipeline_deployments, null: false, default: 500
      t.integer :pull_mirror_interval_seconds, null: false, default: 300
      t.integer :daily_invites, null: false, default: 0
      t.bigint :rubygems_max_file_size, null: false, default: 3221225472
      t.bigint :terraform_module_max_file_size, null: false, default: 1073741824
      t.bigint :helm_max_file_size, null: false, default: 5242880
      t.integer :ci_registered_group_runners, null: false, default: 1000
      t.integer :ci_registered_project_runners, null: false, default: 1000
      t.integer :ci_daily_pipeline_schedule_triggers, null: false, default: 0
      t.integer :ci_max_artifact_size_running_container_scanning, null: false, default: 0
      t.integer :ci_max_artifact_size_cluster_image_scanning, null: false, default: 0
      t.integer :ci_jobs_trace_size_limit, null: false, default: 100
      t.integer :pages_file_entries, null: false, default: 200000
      t.integer :dast_profile_schedules, null: false, default: 1
      t.integer :external_audit_event_destinations, null: false, default: 5
      t.integer :dotenv_variables, null: false, default: 20
      t.integer :dotenv_size, null: false, default: 5120
      t.integer :pipeline_triggers, null: false, default: 25000
      t.integer :project_ci_secure_files, null: false, default: 100
      t.bigint :repository_size
      t.integer :security_policy_scan_execution_schedules, null: false, default: 0
      t.integer :web_hook_calls_mid, null: false, default: 0
      t.integer :web_hook_calls_low, null: false, default: 0
      t.integer :project_ci_variables, null: false, default: 8000
      t.integer :group_ci_variables, null: false, default: 30000
      t.integer :ci_max_artifact_size_cyclonedx, null: false, default: 1
      t.bigint :rpm_max_file_size, null: false, default: 5368709120
      t.integer :ci_max_artifact_size_requirements_v2, null: false, default: 0
      t.integer :pipeline_hierarchy_size, null: false, default: 1000
      t.integer :enforcement_limit, null: false, default: 0
      t.integer :notification_limit, null: false, default: 0
      t.datetime :dashboard_limit_enabled_at
      t.integer :web_hook_calls, null: false, default: 0
      t.integer :project_access_token_limit, null: false, default: 0
      t.integer :google_cloud_logging_configurations, null: false, default: 5
      t.bigint :ml_model_max_file_size, null: false, default: 10737418240
      t.jsonb :limits_history, null: false, default: {}
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.integer :ci_max_artifact_size_annotations, null: false, default: 0
      t.integer :ci_job_annotations_size, null: false, default: 81920
      t.integer :ci_job_annotations_num, null: false, default: 20
      t.float :file_size_limit_mb, null: false, default: 100.0
      t.integer :audit_events_amazon_s3_configurations, null: false, default: 5
      t.bigint :ci_max_artifact_size_repository_xray, null: false, default: 1073741824
      t.integer :active_versioned_pages_deployments_limit_by_namespace, null: false, default: 1000
      t.bigint :ci_max_artifact_size_jacoco, null: false, default: 0
      t.integer :import_placeholder_user_limit_tier_1, null: false, default: 0
      t.integer :import_placeholder_user_limit_tier_2, null: false, default: 0
      t.integer :import_placeholder_user_limit_tier_3, null: false, default: 0
      t.integer :import_placeholder_user_limit_tier_4, null: false, default: 0

      t.index :plan_id, unique: true
    end
  end
end
