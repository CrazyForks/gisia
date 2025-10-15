json.name          service.name
json.entrypoint    service.entrypoint
json.ports         service.ports do |port|
  json.partial! 'jobs/request/port', port: port
end
json.executor_opts service.executor_opts
json.pull_policy   service.pull_policy
json.alias         service.alias
json.command       service.command
json.variables     service.variables
