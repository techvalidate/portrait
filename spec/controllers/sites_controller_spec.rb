require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitesController do
  let(:user)  { FactoryGirl.create(:user)  }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  shared_examples "unauthorized access" do
    it "disallows / with GET" do
      get :index
      response.should_not render_template(:index)
    end
  end

  context "without signing in" do
    it_behaves_like "unauthorized access"
  end

  context "with user signed in" do
    before(:each) { sign_in user }

    it_behaves_like "unauthorized access"
  end

  context "with admin signed in" do
    before(:each) { sign_in admin }

    it "allowes / with GET" do
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
  end

  context "through the api" do
    before(:each) { sign_in user}

    it 'handles / with valid parameters and POST' do
      running {
        post :api, url: 'http://google.com'
        assigns(:site).user.should == user
        response.should be_success
        # checking the entire return string is brittle and will break when code
        # is refactored or tests are run in a different order. Use a regex to 
        # validate the important part and leave the rest alone.
        response.body.should =~  /<state>success<\/state>/
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
end
