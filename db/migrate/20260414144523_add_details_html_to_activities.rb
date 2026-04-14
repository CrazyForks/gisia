class AddDetailsHtmlToActivities < ActiveRecord::Migration[8.0]
  def change
    add_column :activities, :details_html, :text
  end
end
