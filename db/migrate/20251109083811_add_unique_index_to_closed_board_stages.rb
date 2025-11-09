class AddUniqueIndexToClosedBoardStages < ActiveRecord::Migration[8.0]
  def change
    add_index :board_stages, [:board_id, :kind], unique: true, where: "kind = 2", name: 'index_board_stages_on_board_id_and_closed_kind'
  end
end
