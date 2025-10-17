FactoryBot.define do
  after(:build) do |object, _|
    next unless object.respond_to?(:factory_bot_built=)

    object.factory_bot_built = true
  end

  before(:create) do |_object, _|
    Thread.current[:factory_bot_objects] ||= 0
    Thread.current[:factory_bot_objects] += 1
  end
end

FactoryBot::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end
