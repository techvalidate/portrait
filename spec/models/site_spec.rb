require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site, 'relationships' do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:site) { FactoryGirl.create(:site, :user => admin) }

  it 'should belong to a user' do
    site.user.should == admin
  end

  it 'should have an image url' do
    site.image_url.should =~ /sites\/\d\/original/
  end

  context "validations" do
    it 'should have an url' do
      Site.new.should have(1).error_on(:url)
    end

    it 'should have a valid url' do
      Site.new(url: 'invalid').should have(1).error_on(:url)
    end

    it 'should belong to a user' do
      Site.new.should have(1).error_on(:user_id)
    end
  end
end
