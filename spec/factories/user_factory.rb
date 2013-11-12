FactoryGirl.define do
  factory :user do
    sequence(:id)    { |n| n }
    sequence(:name)  { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password         "12345678"
    admin             false

    trait :admin do
      sequence(:name)  { |n| "admin#{n}" }
      sequence(:email) { |n| "admin#{n}@example.com" }
      admin            true
    end
  end
end
