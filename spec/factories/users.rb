FactoryBot.define do
  factory :user do
    id {Faker::Number.number(10)}
    name { Faker::Name.name }
    email { Faker::Internet.email}
    password_digest{Faker::Lorem.word}
  end
end