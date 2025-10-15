class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string  :name, null: false
      t.string  :path, null: false
      t.text    :description
      t.bigint  :namespace_id, null: false
      t.string  :avatar
      t.string  :repository_storage, null: false, default: 'default'
      t.boolean :lfs_enabled, null: false, default: false
      t.integer :storage_version, limit: 2
      t.timestamps null: false
      t.string  :runners_token
      t.string  :runners_token_encrypted
      t.integer :build_timeout, null: false, default: 3600
      t.integer :jobs_cache_index
    end

    # Indexes
    add_index :projects, :namespace_id, unique: true
    add_index :projects, "lower(name)", unique: true, where: nil
  end
end
