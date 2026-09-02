# frozen_string_literal: true

module MarkdownAutocompleteHelper
  def markdown_autocomplete_members_url(noteable)
    project = noteable.try(:project)
    return if project.blank?

    namespace_project_autocomplete_sources_members_path(
      project.namespace.parent.full_path,
      project.path,
      type: noteable.class.name,
      type_id: noteable.iid
    )
  end

  def markdown_autocomplete_commands_url(noteable)
    project = noteable.try(:project)
    return if project.blank?

    namespace_project_autocomplete_sources_commands_path(
      project.namespace.parent.full_path,
      project.path,
      type: noteable.class.name,
      type_id: noteable.iid
    )
  end
end

