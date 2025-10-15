class AddLockversionToCiStages < ActiveRecord::Migration[8.0]
  def change
    change_table :ci_stages, bulk: true do |t|
      t.integer :lock_version, default: 0, null: true
      t.timestamps
    end
  end
end
