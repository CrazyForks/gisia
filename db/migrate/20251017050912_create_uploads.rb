class CreateUploads < ActiveRecord::Migration[8.0]
  def change
    create_table :uploads do |t|
      t.bigint :size, null: false
      t.references :model, null: false, polymorphic: true, index: false
      t.references :uploaded_by_user, index: false
      t.references :namespace
      t.references :project
      t.integer :store, null: false, default: 1
      t.integer :version, default: 1
      t.text :path, null: false
      t.text :checksum
      t.text :uploader, null: false
      t.text :mount_point
      t.text :secret
      t.timestamps


      t.index :store
      t.index :checksum
      t.index [:model_id, :model_type, :uploader, :created_at]
      t.index :uploaded_by_user_id
      t.index [:uploader, :path]
    end
  end
end
