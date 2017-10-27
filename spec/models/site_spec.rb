require 'rails_helper'

describe Site do
  it 'should belong to a user' do
    expect(sites(:google).user).to eq(users(:jordan))
  end

  it 'should require a url' do
    site = Site.new
    site.valid?
    expect(site.errors[:url]).not_to be_empty
  end

  it 'should require a valid url' do
    site = Site.new url: 'invalid'
    site.valid?
    expect(site.errors[:url]).not_to be_empty
  end

  it 'should require a user' do
    site = Site.new
    site.valid?
    expect(site.errors[:user_id]).not_to be_empty
  end

  it 'should have an image url' do
    expect(sites(:google).image_url).to eq('/system/sites/images/000/000/001/original/google.png')
  end
end
