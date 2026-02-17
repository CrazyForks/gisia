class ChangeCiRefIdNullableOnCiPipelines < ActiveRecord::Migration[8.0]
  def change
    change_column_null :ci_pipelines, :ci_ref_id, true
  end
end
