FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    sequence(:path) { |n| "project#{n}" }
    description { Faker::Lorem.sentence }
    
    transient do
      creator { association(:user) }
      parent_namespace { nil }
    end

    after(:build) do |project, evaluator|
      # Mimic the controller behavior for project creation
      project.build_namespace unless project.namespace
      project.namespace.creator_id = evaluator.creator.id
      
      # Projects must have a parent namespace - default to user's namespace
      parent_ns = evaluator.parent_namespace || evaluator.creator.namespace
      project.namespace.parent_id = parent_ns.id
    end
  end
end