class AddIndexToMergeRequestMetricsLatestClosedAt < ActiveRecord::Migration[8.0]
  def change
    add_index :merge_request_metrics, :latest_closed_at
  end
end
