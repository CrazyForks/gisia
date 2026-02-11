# frozen_string_literal: true

class WebhookDeliveryJob < ApplicationJob
  queue_as :default

  def perform(hook_id, data, event_name)
    hook = WebHook.find_by(id: hook_id)
    return unless hook

    WebHookService.new(hook, data, event_name).execute
  end
end
