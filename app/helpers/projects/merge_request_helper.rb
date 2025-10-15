# frozen_string_literal: true

module Projects
  module MergeRequestHelper
    def merge_requests_path(project)
      namespace = project.namespace.parent

      namespace_project_merge_requests_path(namespace.full_path, project.path)
    end

    def merge_request_path(merge_request)
      project = merge_request.project
      namespace = project.namespace.parent

      namespace_project_merge_request_path(namespace.full_path, project.path, merge_request)
    end
  end
end
