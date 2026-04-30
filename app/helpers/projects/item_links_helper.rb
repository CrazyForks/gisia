# frozen_string_literal: true

module Projects
  module ItemLinksHelper
    def item_link_delete_url(item_link)
      source = item_link.source

      if source.is_a?(MergeRequest)
        project = source.target_project
        namespace_project_merge_request_link_path(project.namespace.parent.full_path, project.path, source, item_link)
      else
        project = source.project
        namespace_project_issue_link_path(project.namespace.parent.full_path, project.path, source, item_link)
      end
    end

    def item_link_target_url(target)
      if target.is_a?(MergeRequest)
        project = target.target_project
        namespace_project_merge_request_path(project.namespace.parent.full_path, project.path, target)
      else
        project = target.project
        namespace_project_issue_path(project.namespace.parent.full_path, project.path, target)
      end
    end
  end
end
