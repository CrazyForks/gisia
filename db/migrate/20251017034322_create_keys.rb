class CreateKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :keys do |t|
      t.references :user, null: false, index: true
      t.text :key, null: false
      t.string :title, null: false
      t.string :fingerprint
      t.datetime :last_used_at
      t.binary :fingerprint_sha256
      t.datetime :expires_at
      t.integer :usage_type, null: false, default: 0
      t.timestamps

      t.index :fingerprint
      t.index :fingerprint_sha256, unique: true
      t.index :last_used_at
    end
  end
end
