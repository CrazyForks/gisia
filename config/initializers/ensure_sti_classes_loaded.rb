# Ensure STI classes are loaded to prevent association inheritance issues
Rails.application.config.to_prepare do
  require_dependency 'ci/processable'
  require_dependency 'ci/build'
  require_dependency 'ci/bridge'
end