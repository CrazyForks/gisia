class CreateUserUploads < ActiveRecord::Migration[8.0]
  def change
    create_table :user_uploads do |t|
      t.bigint :size, null: false
      t.references :model, null: false, polymorphic: true, index: false
      t.references :uploaded_by_user, index: false
      t.references :namespace, index: false
      t.references :project, index: false
      t.references :organization, index: false
      t.datetime :created_at
      t.integer :store, null: false, default: 1
      t.integer :version, default: 1
      t.text :path, null: false
      t.text :checksum
      t.text :uploader, null: false
      t.text :mount_point
      t.text :secret

      t.index :checksum
      t.index [:model_id, :model_type, :uploader, :created_at]
      t.index :namespace_id
      t.index :organization_id
      t.index :project_id
      t.index :store
      t.index :uploaded_by_user_id
      t.index [:uploader, :path]
    end
  end
end
