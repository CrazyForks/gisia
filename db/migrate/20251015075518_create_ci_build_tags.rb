class CreateCiBuildTags < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_build_tags do |t|
      t.bigint :tag_id, null: false
      t.bigint :build_id, null: false
      t.bigint :project_id, null: false

      t.index :project_id
      t.index :build_id
      t.index [:tag_id, :build_id], unique: true
    end
  end
end
