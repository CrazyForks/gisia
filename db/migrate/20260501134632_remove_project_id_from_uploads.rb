class RemoveProjectIdFromUploads < ActiveRecord::Migration[8.0]
  def change
    remove_reference :uploads, :project
  end
end
