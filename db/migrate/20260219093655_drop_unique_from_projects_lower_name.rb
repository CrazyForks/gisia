class DropUniqueFromProjectsLowerName < ActiveRecord::Migration[8.0]
  def up
    remove_index :projects, name: :index_projects_on_lower_name
    add_index :projects, "lower(name)", name: :index_projects_on_lower_name
  end

  def down
    remove_index :projects, name: :index_projects_on_lower_name
    add_index :projects, "lower(name)", unique: true, name: :index_projects_on_lower_name
  end
end
