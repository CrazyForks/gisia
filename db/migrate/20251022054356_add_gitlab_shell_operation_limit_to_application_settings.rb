class AddGitlabShellOperationLimitToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :gitlab_shell_operation_limit, :integer, default: 600
  end
end
