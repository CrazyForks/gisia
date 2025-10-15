class AddTokenEncryptedToCiTriggers < ActiveRecord::Migration[8.0]
  def change
    change_table :ci_triggers, bulk: true do |t|
      t.text :token_encrypted, null: true
    end
  end
end
