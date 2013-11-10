require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitesController do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  before(:each) { login_as admin }

  it 'handles / with GET' do
    get :index
    response.should be_success
  end

  it 'handles /sites with valid parameters and POST' do
    running {
      post :create, site: {url: 'http://google.com'}
      assigns(:site).user.should == admin
      response.should redirect_to(sites_path)
    }.should change(Site, :count).by(1)
  end

  it 'handles /sites with invalid url and POST' do
    running {
      post :create, site: {url: 'invalid'}
      response.should be_success
      response.should render_template(:index)
    }.should_not change(Site, :count)
  end

  it 'handles / with valid parameters and POST' do
    running {
      post :api, url: 'http://google.com'
      assigns(:site).user.should == admin
      response.should be_success
      #
      # This test is brittle and breaks when the code is refactored, etc...
      # A regex that matches only the critical part of the message would be
      # more robust.
      # response.body.should ==  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<site>\n  <state>success</state>\n  <image-url>/sites/2/original/2-full.png</image-url>\n</site>\n"
      response.body.should =~ /<state>success<\/state>/
    }.should change(Site, :count).by(1)
  end

  it 'handles / with empty url and POST' do
    running {
      post :api
      response.response_code.should == 500
      response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<errors>\n  <error>Url is invalid</error>\n</errors>\n"
    }.should_not change(Site, :count)
  end

  it 'handles /sites with invalid url and POST' do
    running {
      post :api, :url=>'invalid'
      response.response_code.should == 500
      response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<errors>\n  <error>Url is invalid</error>\n</errors>\n"
    }.should_not change(Site, :count)
  end

end
