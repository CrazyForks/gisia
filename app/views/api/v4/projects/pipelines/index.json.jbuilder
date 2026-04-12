json.array! @pipelines do |pipeline|
  json.partial! 'api/v4/projects/pipelines/pipeline', pipeline: pipeline
end
