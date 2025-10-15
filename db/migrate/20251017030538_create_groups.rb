class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :path, null: false
      t.text :description
      t.references :namespace, null: false, default: 0, index: false
      t.string :avatar
      t.timestamps

      t.index [:namespace_id], unique: true
    end
  end
end

