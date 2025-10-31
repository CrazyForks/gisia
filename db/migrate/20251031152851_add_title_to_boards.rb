class AddTitleToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :title, :string, default: 'Default'
  end
end
