FactoryGirl.define do
  factory :site do
    sequence(:id)      { |n| n }
    image_content_type "image/png"
    image_file_name    "google.png"
    state              :submitted
    url                "http://google.com"
  end
end
