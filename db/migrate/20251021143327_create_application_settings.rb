class CreateApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :application_settings do |t|
      t.text :default_branch_name
      t.boolean :disable_feed_token, default: false, null: false
      t.string :enabled_git_access_protocol
      t.integer :receive_max_input_size
      t.boolean :gitlab_dedicated_instance, default: false, null: false
      t.boolean :admin_mode, default: false, null: false
      t.jsonb :ci_cd_settings, default: {}, null: false
      t.boolean :allow_runner_registration_token, default: true, null: false
      t.string :valid_runner_registrars, array: true, default: ["project", "group"]
      t.integer :runner_token_expiration_interval
      t.string :runners_registration_token_encrypted
      t.integer :max_attachment_size, default: 100, null: false
      t.boolean :require_personal_access_token_expiry, default: true, null: false
      t.boolean :hashed_storage_enabled, default: true, null: false
      t.integer :diff_max_files, default: 1000, null: false
      t.integer :diff_max_lines, default: 50000, null: false
      t.integer :diff_max_patch_bytes, default: 204800, null: false
      t.string :custom_http_clone_url_root, limit: 511
      t.timestamps
    end
  end
end
