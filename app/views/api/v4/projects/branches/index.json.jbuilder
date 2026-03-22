json.array! @branches do |branch|
  json.partial! 'api/v4/projects/branches/branch', branch: branch, project: @project
end
