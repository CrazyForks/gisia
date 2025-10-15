class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :author, null: false
      t.references :merge_request, null: false
      t.references :project, null: false
      t.datetime :created_at, null: false
    end
  end
end
