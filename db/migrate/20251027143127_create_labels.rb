class CreateLabels < ActiveRecord::Migration[8.0]
  def change
    create_table :labels do |t|
      t.string :title
      t.string :color
      t.text :description
      t.bigint :organization_id
      t.integer :rank, default: 0

      t.timestamps
    end

    add_index :labels, :organization_id
    add_index :labels, :rank
  end
end
