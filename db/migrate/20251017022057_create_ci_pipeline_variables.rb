class CreateCiPipelineVariables < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_pipeline_variables do |t|
      t.string :key, null: false
      t.text :value
      t.text :encrypted_value
      t.string :encrypted_value_salt
      t.string :encrypted_value_iv
      t.integer :variable_type, limit: 2, null: false, default: 1
      t.boolean :raw, null: false, default: false
      t.references :pipeline, null: false, index: false
      t.references :project, index: true

      t.index [:pipeline_id, :key], unique: true
    end
  end
end
