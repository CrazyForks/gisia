namespace_path = issue.namespace.full_path

json.id issue.id
json.iid issue.iid
json.project_id issue.namespace.project&.id
json.title issue.title
json.description issue.description
json.state issue.opened? ? 'opened' : 'closed'
json.created_at issue.created_at
json.updated_at issue.updated_at
json.closed_at issue.closed_at

if issue.closed_by
  json.closed_by do
    json.partial! 'api/v4/issues/user', user: issue.closed_by
  end
else
  json.closed_by nil
end

json.labels issue.labels.order(:title).pluck(:title)

json.assignees issue.assignees do |assignee|
  json.partial! 'api/v4/issues/user', user: assignee
end

first_assignee = issue.assignees.first
if first_assignee
  json.assignee do
    json.partial! 'api/v4/issues/user', user: first_assignee
  end
else
  json.assignee nil
end

json.author do
  json.partial! 'api/v4/issues/user', user: issue.author
end

json.epic_id issue.parent_id
json.type 'ISSUE'
json.due_date issue.due_date
json.confidential issue.confidential

json.web_url "#{Gitlab.config.gitlab.url}/#{namespace_path}/issues/#{issue.iid}"

json.references do
  json.short "##{issue.iid}"
  json.relative "##{issue.iid}"
  json.full "#{namespace_path}##{issue.iid}"
end

