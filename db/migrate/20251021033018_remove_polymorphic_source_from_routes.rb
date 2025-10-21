class RemovePolymorphicSourceFromRoutes < ActiveRecord::Migration[8.0]
  def change
    remove_column :routes, :source_id
    remove_column :routes, :source_type
  end
end
