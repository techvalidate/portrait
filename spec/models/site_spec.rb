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
  
  context 'processing' do
    before(:each) do
      allow_any_instance_of(Site).to receive(:copy_from_duplicate_url).and_return(true)
      allow_any_instance_of(Site).to receive(:handle).and_return(true)
    end
    
    context 'with duplicate url and image found' do
      it 'should copy the image from the duplicate site' do
        expect_any_instance_of(Site).to receive(:copy_from_duplicate_url).exactly(1)
        site = Site.create url: 'http://google.com', user: users(:jordan)
        expect(site.valid?).to be true
      end
      
      it 'should not try to attach the file' do
        expect_any_instance_of(Site).not_to receive(:handle)
        site = Site.create url: 'http://google.com', user: users(:jordan)
        expect(site.valid?).to be true
      end
    end
    
    context 'without duplicate url or image not found' do
      it 'should try and attach the file' do
        expect_any_instance_of(Site).to receive(:handle).exactly(1)
        site = Site.create url: 'http://googlish.com', user: users(:jordan)
        expect(site.valid?).to be true
      end
      
      it 'should not try to copy the file' do
        expect_any_instance_of(Site).not_to receive(:copy_from_duplicate_url)
        site = Site.create url: 'http://googlish.com', user: users(:jordan)
        expect(site.valid?).to be true
      end
    end
  end
end
