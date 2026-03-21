# frozen_string_literal: true

class CreateNotificationSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_settings do |t|
      t.references :user, null: false
      t.string :source_type
      t.bigint :source_id
      t.integer :level, null: false, default: 0
      t.boolean :new_note
      t.boolean :new_issue
      t.boolean :reopen_issue
      t.boolean :close_issue
      t.boolean :reassign_issue
      t.boolean :new_merge_request
      t.boolean :close_merge_request
      t.boolean :reassign_merge_request
      t.boolean :merge_merge_request
      t.boolean :change_reviewer_merge_request
      t.boolean :reopen_merge_request
      t.boolean :failed_pipeline
      t.boolean :fixed_pipeline

      t.timestamps
    end

    add_index :notification_settings, [:user_id, :source_type, :source_id],
      unique: true, name: 'index_notification_settings_on_user_and_source'
    add_index :notification_settings, [:source_id, :source_type]
  end
end
