class CreateCiBuildTraceMetadata < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_build_trace_metadata do |t|
      t.references :build, null: false, index: false
      t.references :trace_artifact, index: true
      t.column :last_archival_attempt_at, :timestamptz
      t.column :archived_at, :timestamptz
      t.integer :archival_attempts, limit: 2, null: false, default: 0
      t.binary :checksum
      t.binary :remote_checksum
      t.references :project, index: true

      t.index :build_id, unique: true
    end
  end
end
