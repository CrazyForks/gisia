class CreateBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :boards do |t|
      t.references :project, null: false
      t.references :namespace, null: false
      t.bigint :updated_by_id

      t.timestamps
    end

    add_index :boards, :updated_by_id
  end
end
