class FillNamespaceIdForInternalIds < ActiveRecord::Migration[8.0]
  def up
    InternalId.where(namespace_id: nil).where.not(project_id: nil).find_each do |row|
      project = Project.find_by(id: row.project_id)
      if project&.namespace
        row.update(namespace_id: project.namespace_id)
      end
    end
  end

  def down
  end
end
