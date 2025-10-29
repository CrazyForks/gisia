require 'capybara/rspec'
require 'capybara/cuprite'
require "capybara/cuprite"


timeout = ENV['CI_SERVER'] ? 30 : 5

CAPYBARA_WINDOW_SIZE = [1920, 1080].freeze

Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: CAPYBARA_WINDOW_SIZE,
    browser_options: {
      'no-sandbox': nil,
      'disable-gpu': nil,
      'disable-extensions': nil,
      'disable-dev-shm-usage': nil,
      'disable-web-security': nil,
      'force-device-scale-factor': 1
    },
    process_timeout: 30,
    timeout: 30,
    headless: ENV['HEADLESS'] != 'false'
  )
end

Capybara.javascript_driver = :cuprite
Capybara.default_max_wait_time = timeout
Capybara.ignore_hidden_elements = true
Capybara.default_normalize_ws = true
Capybara.enable_aria_label = true
Capybara.server_host = '127.0.0.1'


RSpec.configure do |config|
  config.before(:example, :js) do
    session = Capybara.current_session

    # reset window size between tests
    if session.respond_to?(:resize_window)
      session.resize_window(*CAPYBARA_WINDOW_SIZE)
    end
  end

  config.after(:example, :js) do |example|
    # prevent localStorage from introducing side effects based on test order
    if Capybara.current_driver == :cuprite
      execute_script('localStorage.clear();') rescue nil
    end

    # Reset sessions unless example failed (for debugging)
    Capybara.reset_sessions! unless example.exception
  end
end
