FactoryBot.define do
  factory :namespace do
    name { Faker::Company.name }
    path { Faker::Internet.unique.username(separators: %w[_]) }
    type { 'Namespaces::UserNamespace' }
    association :owner, factory: :user

    trait :project_namespace do
      type { 'Namespaces::ProjectNamespace' }
    end

    trait :group_namespace do
      type { 'Namespaces::GroupNamespace' }
    end

    factory :user_namespace, parent: :namespace, class: 'Namespaces::UserNamespace' do
      type { 'Namespaces::UserNamespace' }
    end

    factory :project_namespace, parent: :namespace, class: 'Namespaces::ProjectNamespace' do
      type { 'Namespaces::ProjectNamespace' }
    end

    factory :group_namespace, parent: :namespace, class: 'Namespaces::GroupNamespace' do
      type { 'Namespaces::GroupNamespace' }
    end
  end
end