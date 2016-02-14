require 'rails_helper'

describe Site do
  let (:site) { sites(:google) }

  context 'validations' do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:user) }

    it 'should require a valid url' do
      invalid_urls = ['invalid', 'http://foocom', 'http://foo.com1']
      invalid_urls.each do |url|
        site.url = url
        site.valid?
        expect(site.errors[:url]).not_to be_empty
      end
    end
  end

  context 'associations' do
    it { should belong_to(:user) }

    it 'should not save without a valid user' do
      site.user_id = 100
      site.valid?
      expect(site.errors[:user]).not_to be_empty
    end
  end


  it 'should have an image url' do
    expect(site.image_url).to eq('/sites/1/original/google.png')
  end
end
