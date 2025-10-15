class CreateNotes < ActiveRecord::Migration[8.0]
  def up
    create_table :notes, primary_key: %w[id noteable_type], options: 'PARTITION BY LIST (noteable_type)' do |t|
      t.bigserial :id, null: false
      t.text :note
      t.string :noteable_type
      t.bigint :noteable_id
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :updated_by, null: true, foreign_key: { to_table: :users }
      t.string :discussion_id
      t.boolean :system, default: false, null: false
      t.boolean :internal, default: false, null: false
      t.datetime :resolved_at
      t.references :resolved_by, null: true, foreign_key: { to_table: :users }
      t.boolean :confidential
      t.datetime :last_edited_at
      t.references :namespace, null: true, foreign_key: true

      t.timestamps
    end

    add_index :notes, %i[noteable_type noteable_id]
    add_index :notes, :discussion_id
    add_index :notes, :system
    add_index :notes, :internal
    add_index :notes, :confidential
    add_index :notes, :resolved_at

    # Create partition using PARTITION OF syntax
    execute <<-SQL
      CREATE TABLE issue_notes PARTITION OF notes
      FOR VALUES IN ('Issue');
    SQL

    execute <<-SQL
      CREATE TABLE epic_notes PARTITION OF notes
      FOR VALUES IN ('Epic');
    SQL

    execute <<-SQL
      CREATE TABLE merge_request_notes PARTITION OF notes
      FOR VALUES IN ('MergeRequest');
    SQL
  end

  def down
    drop_table :notes
  end
end

