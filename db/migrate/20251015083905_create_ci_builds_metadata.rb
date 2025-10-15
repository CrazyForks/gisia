class CreateCiBuildsMetadata < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_builds_metadata do |t|
      t.references :project, null: false, index: true
      t.integer :timeout
      t.integer :timeout_source, null: false, default: 1
      t.boolean :interruptible
      t.jsonb :config_options
      t.jsonb :config_variables
      t.boolean :has_exposed_artifacts
      t.string :environment_auto_stop_in, limit: 255
      t.string :expanded_environment_name, limit: 255
      t.jsonb :secrets, null: false, default: {}
      t.references :build, null: false, index: false
      t.jsonb :id_tokens, null: false, default: {}
      t.boolean :debug_trace_enabled, null: false, default: false
      t.integer :exit_code, limit: 2

      t.index :build_id, unique: true
    end
  end
end
