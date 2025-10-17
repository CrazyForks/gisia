FactoryBot.define do
  factory :work_item do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    state_id { 1 }
    confidential { false }
    type { 'WorkItem' }
    association :author, factory: :user
    association :namespace

    trait :confidential do
      confidential { true }
    end

    factory :issue, parent: :work_item, class: 'Issue' do
      type { 'Issue' }
    end

    factory :epic, parent: :work_item, class: 'Epic' do
      type { 'Epic' }
    end
  end
end
