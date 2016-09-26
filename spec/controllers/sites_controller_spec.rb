require 'rails_helper'

describe SitesController do
  before { login_as :jordan }

  it 'handles / with GET' do
    get :index
    expect(response).to be_success
  end

  it 'handles /sites with valid parameters and POST' do
    expect {
      post :create, site: { url: 'https://google.com' }
      expect(assigns(:site).user).to eq(@user)
      expect(response).to redirect_to(sites_path)
    }.to change(Site, :count).by(1)
  end

  it 'handles /sites with invalid url and POST' do
    expect {
      post :create, site: { url: 'invalid' }
      expect(response).to be_success
      expect(response).to render_template(:index)
    }.not_to change(Site, :count)
  end

  it 'handles / with valid parameters and POST' do
    expect {
      post :api, url: 'https://google.com'
      expect(assigns(:site).user).to eq(@user)
      expect(response).to be_success
      expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<site>\n  <image-url>/sites/2/original/2-full.png</image-url>\n</site>\n")
    }.to change(Site, :count).by(1)
  end

  it 'handles / with empty url and POST' do
    expect {
      post :api
      expect(response.response_code).to eq(500)
      expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<errors>\n  <error>Url is invalid</error>\n</errors>\n")
    }.not_to change(Site, :count)
  end

  it 'handles /sites with invalid url and POST' do
    expect {
      post :api, url: 'invalid'
      expect(response.response_code).to eq(500)
      expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<errors>\n  <error>Url is invalid</error>\n</errors>\n")
    }.not_to change(Site, :count)
  end

  it 'handles /sites with canceled customer' do
    customer = users(:jordan).customer
    customer.cancel!

    expect {
      post :api, url: 'https://google.com'
      expect(response.response_code).to eq(500)
    }.not_to change(Site, :count)
  end
end
