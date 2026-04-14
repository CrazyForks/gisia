class CreateActivities < ActiveRecord::Migration[8.0]
  def up
    create_table :activities, primary_key: %w[id trackable_type], options: 'PARTITION BY LIST (trackable_type)' do |t|
      t.bigserial :id, null: false
      t.string :trackable_type, null: false
      t.bigint :trackable_id, null: false
      t.bigint :author_id, null: true
      t.integer :action_type, limit: 2, null: false
      t.bigint :note_id, null: true
      t.jsonb :details, null: true
      t.datetime :created_at, null: false
    end

    add_index :activities, %i[trackable_type trackable_id]
    add_index :activities, :author_id
    add_index :activities, :note_id
    add_index :activities, :created_at

    execute <<-SQL
      CREATE TABLE issue_activities PARTITION OF activities
      FOR VALUES IN ('Issue');
    SQL

    execute <<-SQL
      CREATE TABLE merge_request_activities PARTITION OF activities
      FOR VALUES IN ('MergeRequest');
    SQL

    execute <<-SQL
      CREATE TABLE epic_activities PARTITION OF activities
      FOR VALUES IN ('Epic');
    SQL
  end

  def down
    drop_table :activities
  end
end
