class CreateCiJobVariables < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_job_variables do |t|
      t.string :key, null: false
      t.text :encrypted_value
      t.string :encrypted_value_iv
      t.references :job, null: false, index: true
      t.integer :variable_type, null: false, default: 1
      t.integer :source, null: false, default: 0
      t.boolean :raw, null: false, default: false
      t.references :project, index: true

      t.index [:key, :job_id], unique: true
    end
  end
end
