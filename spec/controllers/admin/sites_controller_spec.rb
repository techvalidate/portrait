require 'rails_helper'

describe Admin::SitesController do
  before { login_as(:admin) }

  it 'handles / with GET' do
    get :index
    expect(response).to be_success
  end

  it 'handles /sites with valid parameters and POST' do
    expect {
      post :create, site: { url: 'https://google.com' }
      expect(assigns(:site).user).to eq(@user)
      expect(response).to redirect_to(admin_sites_path)
    }.to change(Site, :count).by(1)
  end

  it 'handles /sites with invalid url and POST' do
    expect {
      post :create, site: { url: 'invalid' }
      expect(response).to be_success
      expect(response).to render_template(:index)
    }.not_to change(Site, :count)
  end

end
