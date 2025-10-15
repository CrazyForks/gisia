class CreateCiBuildPendingStates < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_build_pending_states do |t|
      t.references :build, null: false, index: false
      t.integer :state
      t.integer :failure_reason
      t.binary :trace_checksum
      t.bigint :trace_bytesize
      t.references :project, index: true
      t.timestamps

      t.index :build_id, unique: true
    end
  end
end
