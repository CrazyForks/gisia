class CreateCiJobArtifacts < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_job_artifacts do |t|
      t.references :project, null: false, index: true
      t.integer :file_type, null: false
      t.bigint :size
      t.timestamps
      t.datetime :expire_at
      t.string :file
      t.integer :file_store, default: 1
      t.binary :file_sha256
      t.integer :file_format
      t.integer :file_location
      t.references :job, null: false, index: false
      t.integer :locked, default: 2
      t.integer :accessibility, null: false, default: 0
      t.text :file_final_path
      t.text :exposed_as
      t.text :exposed_paths, array: true

      t.index [:job_id, :file_type], unique: true
      t.index :expire_at
      t.index :file_store
    end
  end
end
