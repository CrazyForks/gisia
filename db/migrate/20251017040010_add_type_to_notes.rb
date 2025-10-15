class AddTypeToNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :notes, :type, :string, null: false
    add_index :notes, :type
  end
end

