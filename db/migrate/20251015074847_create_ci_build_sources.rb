class CreateCiBuildSources < ActiveRecord::Migration[8.0]
  def up
    create_table :ci_build_sources, id: false do |t|
      t.bigint :build_id, null: false
      t.bigint :project_id, null: false
      t.integer :source, limit: 2
      t.integer :pipeline_source, limit: 2

      t.index :pipeline_source
      t.index [:project_id, :build_id]
      t.index [:project_id, :source, :build_id]
    end

    execute "ALTER TABLE ci_build_sources ADD PRIMARY KEY (build_id);"
  end

  def down
    drop_table :ci_build_sources
  end
end
