class AddLockVersionToCiPipelines < ActiveRecord::Migration[8.0]
  def change
    change_table :ci_pipelines, bulk: true do |t|
      t.integer :lock_version, default: 0, null: true
    end
  end
end
