class CreateCiBuildNeeds < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_build_needs do |t|
      t.text :name, null: false
      t.boolean :artifacts, null: false, default: true
      t.boolean :optional, null: false, default: false
      t.references :build, null: false, index: true
      t.references :project, null: true, index: true

      t.index [:build_id, :name], unique: true
    end
  end
end
