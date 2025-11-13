class UpdateProjectIdForInternalIds < ActiveRecord::Migration[8.0]
  def up
    InternalId.where(project_id: nil).find_each do |row|
      namespace = Namespace.find_by(id: row.namespace_id)
      if namespace&.project_namespace?
        row.update(project_id: namespace.project&.id)
      end
    end
  end

  def down
  end
end
