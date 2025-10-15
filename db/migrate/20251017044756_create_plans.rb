class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.timestamps
      t.string :name
      t.string :title
    end
  end
end
