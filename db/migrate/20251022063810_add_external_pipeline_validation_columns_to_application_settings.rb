class AddExternalPipelineValidationColumnsToApplicationSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :application_settings, :external_pipeline_validation_service_timeout, :integer
    add_column :application_settings, :external_pipeline_validation_service_url, :text
    add_column :application_settings, :encrypted_external_pipeline_validation_service_token, :text, null: true
    add_column :application_settings, :encrypted_external_pipeline_validation_service_token_iv, :text, null: true
  end
end
