require 'rails_helper'

describe SitesController, 'html' do
  before {
    login_as :admin 
  }

  it 'handles / with GET' do
    gt :sites
    expect(response).to be_successful
  end

  it 'handles /sites with valid parameters and POST' do
    expect {
      pst :sites, site: { url: 'https://google.com' }
      expect(assigns(:site).user).to eq(@user)
      expect(response).to redirect_to(sites_path)
    }.to change(Site, :count).by(1)
  end

  it 'handles /sites with invalid url and POST' do
    expect {
      pst :sites, site: { url: 'invalid' }
      expect(response).to redirect_to(sites_path)
    }.not_to change(Site, :count)
  end
end

describe SitesController, 'js api' do
  before { login_as :admin }

  it 'handles / with valid parameters and POST' do
    expect {
      pst :sites, site: { url: 'https://google.com' }, format: :json
      expect(assigns(:site).user).to eq(@user)
      expect(response).to be_successful
      expect(response.body).to be_include('"status":"succeeded"')
    }.to change(Site, :count).by(1)
  end

  it 'handles / with empty url and POST' do
    expect {
      pst :sites, format: :json
      expect(response).to be_successful
      expect(response.body).to be_include(':{"errors":{"url":["is invalid"]}}')
    }.not_to change(Site, :count)
  end

  it 'handles /sites with invalid url and POST' do
    expect {
      pst :sites, site: { url: 'invalid' }, format: :json
      expect(response).to be_successful
      expect(response.body).to be_include(':{"errors":{"url":["is invalid"]}}')
    }.not_to change(Site, :count)
  end

end
