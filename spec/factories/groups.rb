FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    sequence(:path) { |n| "group#{n}" }
    description { Faker::Lorem.sentence }
    
    transient do
      creator { association(:user) }
    end

    after(:build) do |group, evaluator|
      # Mimic the controller behavior
      group.build_namespace unless group.namespace
      group.namespace.creator_id = evaluator.creator.id
    end
  end
end