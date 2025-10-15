class CreateProjectFeatures < ActiveRecord::Migration[8.0]
  def change
    create_table :project_features do |t|
      t.references :project, null: false, index: false
      t.integer :merge_requests_access_level
      t.integer :issues_access_level
      t.integer :wiki_access_level
      t.integer :snippets_access_level, null: false, default: 20
      t.integer :builds_access_level
      t.integer :repository_access_level, null: false, default: 20
      t.integer :pages_access_level, null: false
      t.integer :forking_access_level
      t.integer :metrics_dashboard_access_level
      t.integer :requirements_access_level, null: false, default: 20
      t.integer :operations_access_level, null: false, default: 20
      t.integer :analytics_access_level, null: false, default: 20
      t.integer :security_and_compliance_access_level, null: false, default: 10
      t.integer :container_registry_access_level, null: false, default: 0
      t.integer :package_registry_access_level, null: false, default: 0
      t.integer :monitor_access_level, null: false, default: 20
      t.integer :infrastructure_access_level, null: false, default: 20
      t.integer :feature_flags_access_level, null: false, default: 20
      t.integer :environments_access_level, null: false, default: 20
      t.integer :releases_access_level, null: false, default: 20
      t.integer :model_experiments_access_level, null: false, default: 20
      t.integer :model_registry_access_level, null: false, default: 20
      t.timestamps

      t.index :project_id, unique: true
      t.index :project_id, where: 'builds_access_level = 20', name: 'index_project_features_on_project_id_bal_20'
      t.index :project_id, where: 'package_registry_access_level = 30', name: 'index_project_features_on_project_id_on_public_package_registry'
      t.index :project_id, where: 'repository_access_level = 20', name: 'index_project_features_on_project_id_ral_20'
    end
  end
end
