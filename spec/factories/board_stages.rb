FactoryBot.define do
  factory :board_stage do
    board { nil }
    title { "MyString" }
    label_ids { "" }
    order { 1 }
  end
end
