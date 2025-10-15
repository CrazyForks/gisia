class CreateMergeRequestReviewers < ActiveRecord::Migration[8.0]
  def change
    create_table :merge_request_reviewers do |t|
      t.references :user, null: false, index: true
      t.references :merge_request, null: false, index: false
      t.references :project, null: false, index: true
      t.integer :state, limit: 2, null: false, default: 0
      t.datetime :created_at, null: false

      t.index [:merge_request_id, :user_id], unique: true
      t.index [:user_id, :state], where: 'state = 2'
    end
  end
end
