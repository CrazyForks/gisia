# frozen_string_literal: true

Rails.application.config.after_initialize do
  Wisper.subscribe(Gisia::WebhookListener.new)
end

