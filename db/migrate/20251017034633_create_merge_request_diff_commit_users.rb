class CreateMergeRequestDiffCommitUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :merge_request_diff_commit_users do |t|
      t.text :name
      t.text :email
      t.references :organization

      t.index [:name, :email], unique: true
      t.index [:organization_id, :name, :email], unique: true
    end
  end
end
