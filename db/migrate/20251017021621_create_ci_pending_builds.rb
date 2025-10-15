class CreateCiPendingBuilds < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_pending_builds do |t|
      t.references :build, null: false, index: false
      t.references :project, null: false, index: true
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.boolean :protected, null: false, default: false
      t.boolean :instance_runners_enabled, null: false, default: false
      t.references :namespace, index: true
      t.boolean :minutes_exceeded, null: false, default: false
      t.bigint :tag_ids, array: true, default: []
      t.bigint :namespace_traversal_ids, array: true, default: []
      t.references :plan, index: true

      t.index :build_id, unique: true
      t.index :namespace_traversal_ids, using: :gin
    end
  end
end
