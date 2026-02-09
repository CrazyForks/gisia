class AddDescriptionHtmlToMergeRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :merge_requests, :description_html, :text
  end
end
