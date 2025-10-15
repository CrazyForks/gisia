class CreateMergeRequestAssignees < ActiveRecord::Migration[8.0]
  def change
    create_table :merge_request_assignees do |t|
      t.references :user, null: false, index: true
      t.references :merge_request, null: false, index: false
      t.references :project, index: true
      t.datetime :created_at

      t.index [:merge_request_id, :user_id], unique: true
    end
  end
end
