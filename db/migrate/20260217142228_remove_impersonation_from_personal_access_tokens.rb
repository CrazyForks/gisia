class RemoveImpersonationFromPersonalAccessTokens < ActiveRecord::Migration[8.0]
  def change
    remove_index :personal_access_tokens, name: 'idx_pat_on_user_id_created_at_no_impersonation'
    remove_column :personal_access_tokens, :impersonation, :boolean, default: false, null: false
  end
end
