json.array! @jobs do |job|
  json.partial! 'api/v4/projects/jobs/job', job: job
end
