json.id dependency.id
json.name dependency.name
json.token running_job.token if running_job.present?

if dependency.available_artifacts?
  json.artifacts_file do
    json.partial! 'artifact_file', artifact: dependency.artifacts_file
  end
end

