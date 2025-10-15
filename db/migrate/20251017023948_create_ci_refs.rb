class CreateCiRefs < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_refs do |t|
      t.references :project, null: false, index: false
      t.integer :lock_version, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.text :ref_path, null: false
      t.timestamps

      t.index [:project_id, :ref_path], unique: true
    end
  end
end
