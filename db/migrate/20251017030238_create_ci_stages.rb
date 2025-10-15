class CreateCiStages < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_stages do |t|
      t.references :project, null: false, index: true
      t.string :name, null: false
      t.integer :status, default: 0
      t.integer :position
      t.references :pipeline, null: false, index: false

      t.index [:pipeline_id, :name], unique: true
      t.index [:pipeline_id, :position]
    end
  end
end
