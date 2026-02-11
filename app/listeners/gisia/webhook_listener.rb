# frozen_string_literal: true

module Gisia
  class WebhookListener
    def branch_push(project, payload)
      deliver_hooks(project, payload, :branch_push, 'Branch Push Hook')
    end

    def tag_push(project, payload)
      deliver_hooks(project, payload, :tag_push, 'Tag Push Hook')
    end

    private

    def deliver_hooks(project, payload, scope, event_name)
      ProjectHook.for_projects(project).public_send(scope).find_each do |hook|
        WebhookDeliveryJob.perform_later(hook.id, payload, event_name)
      end
    end
  end
end

