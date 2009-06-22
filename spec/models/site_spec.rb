require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site, 'relationships' do
  it 'should belong to a user' do
    sites(:google).user.should == users(:jordan)
  end
end

describe Site do
  it 'should have an image url' do
    sites(:google).image_url.should == '/sites/1/original/google.png'
  end
  
  it 'should have to_xml' do
    sites(:google).to_xml == 
    '<site>
      <state>success</state>
      <image_url>/sites/1/original/google.png</image_url>
    </site>'
  end
end

describe Site, 'validations' do
  it 'should have an url' do
    Site.new.should have(1).error_on(:url)
  end
  
  it 'should have a valid url' do
    Site.new(:url=>'invalid').should have(1).error_on(:url)
  end
  
  it 'should belong to a user' do
    Site.new.should have(1).error_on(:user_id)
  end
end
