class AddDescriptionHtmlToWorkItems < ActiveRecord::Migration[8.0]
  def change
    add_column :work_items, :description_html, :text
  end
end
