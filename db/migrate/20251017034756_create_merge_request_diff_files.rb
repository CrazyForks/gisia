class CreateMergeRequestDiffFiles < ActiveRecord::Migration[8.0]
  def up
    create_table :merge_request_diff_files, id: false do |t|
      t.bigint :id, null: false
      t.references :merge_request_diff, null: false, index: false
      t.integer :relative_order, null: false
      t.boolean :new_file, null: false
      t.boolean :renamed_file, null: false
      t.boolean :deleted_file, null: false
      t.boolean :too_large, null: false
      t.string :a_mode, null: false
      t.string :b_mode, null: false
      t.text :new_path, null: false
      t.text :old_path, null: false
      t.text :diff
      t.boolean :binary
      t.integer :external_diff_offset
      t.integer :external_diff_size
      t.boolean :generated
      t.boolean :encoded_file_path, null: false, default: false
      t.references :project, index: true
    end

    execute "CREATE SEQUENCE IF NOT EXISTS merge_request_diff_files_id_seq"
    execute "ALTER TABLE merge_request_diff_files ADD PRIMARY KEY (merge_request_diff_id, relative_order);"
  end

  def down
    drop_table :merge_request_diff_files
  end
end
