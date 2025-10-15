class CreateCiRunnerTaggings < ActiveRecord::Migration[8.0]
  def up
    create_table :ci_runner_taggings do |t|
      t.references :tag, null: false, index: false
      t.references :runner, null: false, index: false
      t.references :sharding_key, index: true
      t.integer :runner_type, null: false

      t.index [:runner_id, :runner_type]
      t.index [:tag_id, :runner_id, :runner_type], unique: true
    end
  end

  def down
    drop_table :ci_runner_taggings
  end
end
