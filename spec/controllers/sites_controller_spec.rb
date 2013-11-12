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

  describe ".api" do
    context "with valid user credentials" do
      let(:valid_api_credentials) do
        post :api, :url      => url,
                   :email    => user.email,
                   :password => user.password
      end
      context 'with a valid url' do
        let(:url) { "http://google.com" }

        it 'succeeds, finds the right user, and adds a site to the database' do
          running {
            valid_api_credentials
            # checking the entire return string is brittle and will break when code
            # is refactored or tests are run in a different order. Use a regex to 
            # validate the important part and leave the rest alone.
            response.body.should =~  /<state>success<\/state>/
            assigns(:site).user.should == user
            response.should be_success
          }.should change(Site, :count).by(1)
        end
      end
      context 'with and empty url' do
        let(:url) { "" }
        it 'handles / with empty url and POST' do
          running {
            valid_api_credentials
            response.response_code.should == 500
            response.body.should =~ /<error>Url is invalid<\/error>/
          }.should_not change(Site, :count)
        end
      end
      context 'with an invalid url' do
        let(:url) { 'invalid' }
        it 'handles /sites with invalid url and POST' do
          running {
            valid_api_credentials
            response.response_code.should == 500
            response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<errors>\n  <error>Url is invalid</error>\n</errors>\n"
          }.should_not change(Site, :count)
        end
      end
    end
    context 'with invalid credentials' do
      let(:url)      { 'http://google.com' }
      let(:email)    { user.email }
      let(:password) { user.password }
      let(:invalid_api_credentials) do
        post :api, url: url, email: email, password: password
      end
      context 'without an email' do
        let(:email) { }

        it 'returns an error' do
          invalid_api_credentials
          response.body.should =~ /<error>Email is nil<\/error>/
        end
      end
      context 'with an invalid email' do
        let(:email) { 'INVALID' }

        it 'returns email not found' do
          invalid_api_credentials
          response.body.should =~ /<error>Email not found<\/error>/
        end
      end
      context 'without a password' do
        let(:password) {}
        it 'returns an error' do
          invalid_api_credentials
          response.body.should =~ /<error>Password is nil<\/error>/
        end
      end
      context 'with an invalid password' do
        let(:password) { 'INVALID' }
        it 'returns invalid password' do
          invalid_api_credentials
          response.body.should =~ /<error>Password Invalid<\/error>/
        end
      end
    end
  end
end
