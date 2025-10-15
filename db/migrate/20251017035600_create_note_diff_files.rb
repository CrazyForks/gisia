class CreateNoteDiffFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :note_diff_files do |t|
      t.text :diff, null: false
      t.boolean :new_file, null: false
      t.boolean :renamed_file, null: false
      t.boolean :deleted_file, null: false
      t.string :a_mode, null: false
      t.string :b_mode, null: false
      t.text :new_path, null: false
      t.text :old_path, null: false
      t.references :diff_note, null: false, index: false

      t.index :diff_note_id, unique: true
    end
  end
end
