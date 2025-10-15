class CreateCiBuildTraceChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_build_trace_chunks do |t|
      t.integer :chunk_index, null: false, default: 0
      t.integer :data_store, null: false, default: 0
      t.binary :raw_data
      t.binary :checksum
      t.integer :lock_version, null: false, default: 0
      t.bigint :build_id, null: false
      t.bigint :project_id

      t.index [:build_id, :chunk_index], unique: true
      t.index :project_id
    end
  end
end
