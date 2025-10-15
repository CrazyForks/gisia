class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.integer :access_level, null: false, default: 0
      t.references :user, null: false, index: true
      t.references :created_by
      t.references :namespace, null: false, index: false
      t.timestamps
      t.string :type, null: false
      t.date :expires_at
      t.datetime :requested_at

      t.index :type
      t.index [:namespace_id, :user_id], unique: true
    end
  end
end
