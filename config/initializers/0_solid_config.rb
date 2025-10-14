# frozen_string_literal: true

solid_queue_config_initializer = SolidQueue::Engine.instance.initializers.find { |i| i.name == 'solid_queue.config' }
solid_queue_config_initializer&.run(Rails.application)

def setup_solid_connections
  SolidQueue::Record.define_singleton_method(:connection) do
    retrieve_connection
  end

  SolidCache::Record.define_singleton_method(:connection) do
    retrieve_connection
  end
end

Rails.application.config.after_initialize do
  setup_solid_connections
end

Rails.application.reloader.to_prepare do
  if Gitlab.dev_or_test_env?
    # Hook into the load balancer setup completion
    ActiveSupport.on_load(:gitlab_db_load_balancer) do
      setup_solid_connections
    end
  end
end

