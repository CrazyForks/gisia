json.id              @job.id
json.token           @job.token
json.allow_git_fetch @job.allow_git_fetch
json.job_info do
  json.partial! 'job_info'
end
json.git_info do
  json.partial! 'git_info'
end
json.runner_info do
  json.partial! 'runner_info'
end

json.variables @job.runner_variables

unless @job.execution_config&.run_steps.present?
  json.steps @job.steps do |step|
    json.partial! 'step', step: step
  end
end

json.hooks @job.runtime_hooks do |hook|
  json.partial! 'hook', hook: hook
end

json.image do
  if @job.image
    json.partial! 'image', image: @job.image
  else
    json.nil!
  end
end


json.services do
  if @job.services.present?
    @job.services.each do |service|
      json.partial! 'service', service: service
    end
  else
    json.array! []
  end
end

json.artifacts do
  if @job.artifacts.present?
    json.partial! 'artifacts', artifacts: @job.artifacts
  else
    json.nil!
  end
end

json.cache do
  if @job.cache.present?
    json.partial! 'cache', cache: @job.cache
  else
    json.array! []
  end
end

json.credentials @job.credentials do |credential|
  json.partial! 'credential', credential: credential
end

json.features @job.features

json.dependencies @job.all_dependencies do |dependency|
  json.partial! 'dependency', dependency: dependency, running_job: @job
end

if @job.execution_config&.run_steps.present?
  json.run @job.execution_config.run_steps
end


