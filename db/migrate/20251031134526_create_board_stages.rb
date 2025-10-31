class CreateBoardStages < ActiveRecord::Migration[8.0]
  def change
    create_table :board_stages do |t|
      t.references :board, null: false
      t.string :title
      t.jsonb :label_ids, default: [], null: false
      t.integer :rank, default: 0, null: false

      t.timestamps
    end
  end
end
