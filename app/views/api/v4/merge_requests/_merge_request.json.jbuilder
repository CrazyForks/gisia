project = merge_request.target_project
namespace_path = "#{project.namespace.parent.full_path}/#{project.path}"

json.id merge_request.id
json.iid merge_request.iid
json.project_id project.id
json.title merge_request.title
json.description merge_request.description
json.state merge_request.status
json.source_branch merge_request.source_branch
json.target_branch merge_request.target_branch
json.source_project_id merge_request.source_project_id
json.target_project_id merge_request.target_project_id
json.created_at merge_request.created_at
json.updated_at merge_request.updated_at
json.merged_at merge_request.merged_at
json.merge_commit_sha merge_request.merge_commit_sha
json.diff_head_sha merge_request.diff_head_sha
json.merge_status merge_request.merge_status

json.author do
  json.partial! 'api/v4/issues/user', user: merge_request.author
end

json.assignees merge_request.assignees do |assignee|
  json.partial! 'api/v4/issues/user', user: assignee
end

first_assignee = merge_request.assignees.first
if first_assignee
  json.assignee do
    json.partial! 'api/v4/issues/user', user: first_assignee
  end
else
  json.assignee nil
end

json.reviewers merge_request.reviewers do |reviewer|
  json.partial! 'api/v4/issues/user', user: reviewer
end

json.web_url "#{Gitlab.config.gitlab.url}/#{namespace_path}/-/merge_requests/#{merge_request.iid}"

json.references do
  json.short "!#{merge_request.iid}"
  json.relative "!#{merge_request.iid}"
  json.full "#{namespace_path}!#{merge_request.iid}"
end
