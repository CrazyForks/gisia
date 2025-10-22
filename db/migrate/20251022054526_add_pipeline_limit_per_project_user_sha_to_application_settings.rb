class AddPipelineLimitPerProjectUserShaToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :pipeline_limit_per_project_user_sha, :integer, null: false, default: 0
  end
end
