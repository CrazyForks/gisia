json.name          image.name
json.entrypoint    image.entrypoint
json.ports         image.ports do |port|
  json.partial! 'jobs/request/port', port: port
end
json.executor_opts image.executor_opts
json.pull_policy   image.pull_policy
