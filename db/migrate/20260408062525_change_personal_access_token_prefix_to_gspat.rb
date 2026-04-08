class ChangePersonalAccessTokenPrefixToGspat < ActiveRecord::Migration[8.0]
  def up
    change_column_default :application_settings, :personal_access_token_prefix, from: 'glpat-', to: 'gspat-'
  end

  def down
    change_column_default :application_settings, :personal_access_token_prefix, from: 'gspat-', to: 'glpat-'
  end
end
