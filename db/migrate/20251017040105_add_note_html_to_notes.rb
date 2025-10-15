class AddNoteHtmlToNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :notes, :note_html, :text
  end
end

