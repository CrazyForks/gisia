class CreateCiInstanceVariables < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_instance_variables do |t|
      t.integer :variable_type, limit: 2, null: false, default: 1
      t.boolean :masked, default: false
      t.boolean :protected, default: false
      t.text :key, null: false
      t.text :encrypted_value
      t.text :encrypted_value_iv
      t.boolean :raw, null: false, default: false
      t.text :description

      t.index :key, unique: true
    end
  end
end
