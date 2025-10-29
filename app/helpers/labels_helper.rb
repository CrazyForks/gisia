module LabelsHelper
  def labels_path(ins)
    namespace_project_settings_labels_path(ins.namespace.parent.full_path, ins.namespace.path)
  end

  def new_label_path(ins)
    new_form_namespace_project_settings_labels_path(ins.namespace.parent.full_path, ins.namespace.path)
  end

  def edit_label_path(ins, label)
    edit_form_namespace_project_settings_label_path(ins.namespace.parent.full_path, ins.namespace.path, label)
  end

  def delete_label_path(ins, label)
    namespace_project_settings_label_path(ins.namespace.parent.full_path, ins.namespace.path, label)
  end
end
