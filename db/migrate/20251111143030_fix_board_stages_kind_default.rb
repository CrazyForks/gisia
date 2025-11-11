class FixBoardStagesKindDefault < ActiveRecord::Migration[8.0]
  def change
    remove_column :board_stages, :kind
    add_column :board_stages, :kind, :integer, default: 1
  end
end
