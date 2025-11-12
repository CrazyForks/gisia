# frozen_string_literal: true

FactoryBot.define do
  factory :epic, class: 'Epic', traits: [:has_internal_id]  do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :author, factory: :user
    association :namespace

    trait :confidential do
      confidential { true }
    end
  end
end
