namespace_path = epic.namespace.full_path

json.id epic.id
json.iid epic.iid
json.project_id epic.namespace.project.id
json.title epic.title
json.description epic.description
json.state epic.opened? ? 'opened' : 'closed'
json.created_at epic.created_at
json.updated_at epic.updated_at
json.closed_at epic.closed_at

if epic.closed_by
  json.closed_by do
    json.partial! 'api/v4/issues/user', user: epic.closed_by
  end
else
  json.closed_by nil
end

json.labels epic.labels.order(:title).pluck(:title)

json.author do
  json.partial! 'api/v4/issues/user', user: epic.author
end

json.type 'EPIC'
json.due_date epic.due_date
json.confidential epic.confidential

json.web_url "#{Gitlab.config.gitlab.url}/#{namespace_path}/epics/#{epic.iid}"

json.references do
  json.short "&#{epic.iid}"
  json.relative "&#{epic.iid}"
  json.full "#{namespace_path}&#{epic.iid}"
end
