FactoryBot.define do
  factory :note do
    note { Faker::Lorem.paragraph }
    association :author, factory: :user
    association :namespace

    trait :system do
      system { true }
      note { "System note" }
    end

    trait :internal do
      internal { true }
    end

    trait :resolved do
      resolved_at { 1.hour.ago }
      association :resolved_by, factory: :user
    end

    factory :issue_note, parent: :note, class: 'IssueNote' do
      association :noteable, factory: :issue
      noteable_type { 'Issue' }
    end

    factory :epic_note, parent: :note, class: 'EpicNote' do
      association :noteable, factory: :epic
      noteable_type { 'Epic' }
    end

    factory :merge_request_note, parent: :note, class: 'MergeRequestNote' do
      association :noteable, factory: :merge_request
      noteable_type { 'MergeRequest' }
    end
  end
end