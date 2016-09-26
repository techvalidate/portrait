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
    expect(sites(:google).image_url).to eq('/sites/1/original/google.png')
  end

  it 'should be queryable by date range' do
    expect(Site.within_dates(1.day.ago, 1.day.since).count).to eq(16)
    expect(Site.within_dates(2.days.ago, 1.day.ago).count).to eq(0)
  end
end
