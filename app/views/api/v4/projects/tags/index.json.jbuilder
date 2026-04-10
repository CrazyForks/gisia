json.array! @tags do |tag|
  json.partial! 'api/v4/projects/tags/tag', tag: tag, project: @project
end
