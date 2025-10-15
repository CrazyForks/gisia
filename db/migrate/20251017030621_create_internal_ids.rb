class CreateInternalIds < ActiveRecord::Migration[8.0]
  def change
    create_table :internal_ids do |t|
      t.references :project, index: true
      t.integer :usage, null: false
      t.integer :last_value, null: false
      t.references :namespace, index: true
      t.timestamps

      t.index [:usage, :namespace_id], unique: true, where: 'namespace_id IS NOT NULL'
      t.index [:usage, :project_id], unique: true, where: 'project_id IS NOT NULL'
    end
  end
end
