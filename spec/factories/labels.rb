FactoryBot.define do
  factory :label do
    title { Faker::Lorem.word }
    color { '#6366F1' }
    description { Faker::Lorem.sentence }
    rank { 0 }
    association :namespace
  end
end
