# frozen_string_literal: true

FactoryBot.define do
  factory :ci_variable, class: 'Ci::Variable' do
    sequence(:key) { |n| "VARIABLE_#{n}" }
    value { 'test_value' }
    variable_type { :env_var }
    masked { false }
    protected { false }
    association :namespace, factory: :project_namespace
  end
end
