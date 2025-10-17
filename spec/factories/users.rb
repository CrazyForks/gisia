FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.unique.username(separators: %w[_]) }
    email { Faker::Internet.unique.email }
    password { Devise.friendly_token }
    confirmed_at { Time.current }
    state { :active }
  end
end
