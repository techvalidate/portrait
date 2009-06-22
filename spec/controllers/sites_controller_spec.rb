require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitesController do

  it 'handles / with GET' do
    get :index
    response.should be_success
  end
  
  it 'handles /sites with valid parameters and POST' do
    running { 
      post :create, :site=>{:url=>'http://google.com'}
      response.should redirect_to(sites_path)
    }.should change(Site, :count).by(1)
  end
  
  it 'handles /sites with empty url and POST' do
    running {
      post :create
      response.should redirect_to(sites_path)
    }.should_not change(Site, :count)
  end
  
  it 'handles /sites with invalid url and POST' do
    running {
      post :create, :site=>{:url=>'invalid'}
      response.should redirect_to(sites_path)
    }.should_not change(Site, :count)
  end

end