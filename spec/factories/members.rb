FactoryBot.define do
  factory :project_member do
    user
    access_level { :developer }
    type { 'ProjectMember' }

    transient do
      project { nil }
    end

    after(:build) do |member, evaluator|
      if evaluator.project
        member.namespace = evaluator.project.namespace
      end
    end
  end
end
