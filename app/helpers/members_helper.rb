module MembersHelper
  def settings_members_path(project)
    namespace_project_settings_members_path(project.namespace.parent.full_path, project.namespace.path)
  end

  def delete_member_path(project, member)
    namespace_project_settings_member_path(project.namespace.parent.full_path, project.namespace.path, member)
  end

  def new_member_form_path(project)
    new_form_namespace_project_settings_members_path(project.namespace.parent.full_path, project.namespace.path)
  end

  def edit_member_form_path(project, member)
    edit_form_namespace_project_settings_member_path(project.namespace.parent.full_path, project.namespace.path, member)
  end

  def update_member_path(project, member)
    namespace_project_settings_member_path(project.namespace.parent.full_path, project.namespace.path, member)
  end
end
