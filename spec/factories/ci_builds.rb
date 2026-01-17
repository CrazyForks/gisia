FactoryBot.define do
  factory :ci_build, class: 'Ci::Build' do
    name { 'test_build' }
    stage_idx { 0 }
    ref { 'main' }
    protected { true }
    tag { false }
    allow_failure { false }
    processed { false }
    user

    association :project
    association :pipeline, factory: :ci_pipeline
    association :stage, factory: :ci_stage
  end
end
