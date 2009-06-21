require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site, 'validations' do
  
  it 'should have an url' do
    Site.new.should have(1).error_on(:url)
  end
  
  it 'should have a valid url' do
    Site.new(:url=>'invalid').should have(1).error_on(:url)
  end
  
end
