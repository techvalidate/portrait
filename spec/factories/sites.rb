FactoryBot.define do
  factory :site do
    id {Faker::Number.number(10)}
    url { Faker::Internet.url }
    user_id {Faker::Number.number(10)}
  end
end