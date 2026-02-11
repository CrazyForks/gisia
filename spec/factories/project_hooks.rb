FactoryBot.define do
  factory :project_hook do
    sequence(:url) { |n| "https://example.com/hook/#{n}" }
    name { Faker::Lorem.word }
    push_events { true }
    tag_push_events { false }
    type { 'ProjectHook' }

    transient do
      project { nil }
    end

    after(:build) do |hook, evaluator|
      if evaluator.project
        hook.namespace = evaluator.project.namespace
      end
    end
  end
end
