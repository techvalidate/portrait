FactoryBot.define do
  factory :site do
    user
    status  { Site.statuses['succeeded'] }
    url 'http://google.com'
  end
end
