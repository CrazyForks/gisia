class CreateCiVariables < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_variables do |t|
      t.string :key, null: false
      t.text :value
      t.text :encrypted_value
      t.string :encrypted_value_salt
      t.string :encrypted_value_iv
      t.references :namespace, null: false, index: false
      t.boolean :protected, null: false, default: false
      t.string :environment_scope, null: false, default: '*'
      t.boolean :masked, null: false, default: false
      t.integer :variable_type, limit: 2, null: false, default: 1
      t.boolean :raw, null: false, default: false
      t.text :description
      t.boolean :hidden, null: false, default: false

      t.index :key
      t.index [:namespace_id, :key, :environment_scope], unique: true
    end
  end
end
