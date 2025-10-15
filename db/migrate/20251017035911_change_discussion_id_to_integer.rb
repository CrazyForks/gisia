class ChangeDiscussionIdToInteger < ActiveRecord::Migration[8.0]
  class ChangeDiscussionIdToInteger < ActiveRecord::Migration[8.0]
    def up
      remove_column :notes, :discussion_id

      add_column :notes, :discussion_id, :bigint, null: true

      add_index :notes, :discussion_id
    end

    def down
      remove_column :notes, :discussion_id
      add_column :notes, :discussion_id, :string
      add_index :notes, :discussion_id
    end
  end
end
