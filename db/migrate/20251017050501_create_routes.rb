class CreateRoutes < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')

    create_table :routes do |t|
      t.references :source, null: false, polymorphic: true, index: false
      t.string :path, null: false
      t.string :name
      t.references :namespace, null: false, index: false
      t.timestamps

      t.index :namespace_id, unique: true
      t.index :path, unique: true
    end

    add_index :routes, 'lower(path)'
    add_index :routes, :name, opclass: :gin_trgm_ops, using: :gin
  end
end
