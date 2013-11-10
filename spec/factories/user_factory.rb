FactoryGirl.define do
  factory :user do
    sequence(:id)   { |n| n }
    sequence(:name) { |n| "user#{n}" }
    password        "test"
    admin            false

    trait :admin do
      sequence(:name) { |n| "admin#{n}" }
      admin           true
    end
  end
end
