class AddWorkflowsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :workflows, :string, default: 'workflow::'
  end
end
