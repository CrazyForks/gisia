class AddPublicJobsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :public_jobs, :boolean, default: true, null: false
  end
end
