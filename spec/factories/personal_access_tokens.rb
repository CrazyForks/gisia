FactoryBot.define do
  factory :personal_access_token do
    user
    sequence(:name) { |n| "token-#{n}" }
    scopes { [:api] }
    expires_at { 30.days.from_now }
    revoked { false }

    trait :revoked do
      revoked { true }
    end
  end
end
