class CreateWebHooks < ActiveRecord::Migration[8.0]
  def change
    create_table :web_hooks do |t|
      t.bigint :namespace_id, null: false

      t.string :type, default: 'ProjectHook', null: true
      t.boolean :push_events, default: true, null: false
      t.boolean :tag_push_events, default: false, null: true
      t.string :encrypted_url
      t.string :encrypted_url_iv
      t.text :name
      t.text :description

      t.timestamps
    end

    add_index :web_hooks, :namespace_id
    add_index :web_hooks, :type
  end
end

