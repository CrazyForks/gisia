# frozen_string_literal: true

class CreateItemLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :item_links do |t|
      t.bigint :source_id, null: false
      t.string :source_type, null: false
      t.bigint :target_id, null: false
      t.string :target_type, null: false
      t.bigint :namespace_id, null: false
      t.boolean :auto_close, null: false, default: false

      t.timestamps
    end

    add_index :item_links, :namespace_id
    add_index :item_links, :source_type
    add_index :item_links, :target_type
    add_index :item_links, [:source_id, :source_type, :target_id, :target_type], unique: true, name: 'index_item_links_on_source_and_target'
  end
end
