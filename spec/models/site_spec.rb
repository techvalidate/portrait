require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site, 'lifecycle' do
  before(:each) do
    @site = Site.new :url=>'http://google.com'
    @site.stub!(:generate_png).and_return '/path/to/png'
  end
  
  it 'should successfully process after save' do
    site = Site.new :url=>'http://google.com'
    site.save
    site.should be_success
  end
end

describe Site, 'validations' do
  it 'should have an url' do
    Site.new.should have(1).error_on(:url)
  end
  
  it 'should have a valid url' do
    Site.new(:url=>'invalid').should have(1).error_on(:url)
  end
end
