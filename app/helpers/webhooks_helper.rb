module WebhooksHelper
  def webhooks_path(ins)
    namespace_project_settings_webhooks_path(ins.namespace.parent.full_path, ins.namespace.path)
  end

  def new_webhook_path(ins)
    new_form_namespace_project_settings_webhooks_path(ins.namespace.parent.full_path, ins.namespace.path)
  end

  def edit_webhook_path(ins, webhook)
    edit_form_namespace_project_settings_webhook_path(ins.namespace.parent.full_path, ins.namespace.path, webhook)
  end

  def delete_webhook_path(ins, webhook)
    namespace_project_settings_webhook_path(ins.namespace.parent.full_path, ins.namespace.path, webhook)
  end
end
