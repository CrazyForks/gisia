class AddPositionFieldsToNotes < ActiveRecord::Migration[8.0]
  def change
    change_table :notes, bulk: true do |t|
      t.text :position, null: true
      t.text :original_position, null: true
      t.text :change_position, null: true
      t.string :line_code, null: true
    end
  end
end
