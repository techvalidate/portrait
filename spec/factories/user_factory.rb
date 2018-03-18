FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "Test User #{n}" }
    password 'password'
  end
end
