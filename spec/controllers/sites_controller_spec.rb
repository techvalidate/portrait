require 'rails_helper'

describe SitesController do
  before do
    login_as :joe
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
      expect(response.body).to include("Url can't be blank")
    }.not_to change(Site, :count)
  end

  it 'handles /sites with invalid url and POST' do
    expect {
      post :api, url: 'invalid'
      expect(response.response_code).to eq(500)
      expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<errors>\n  <error>Url is invalid</error>\n</errors>\n")
    }.not_to change(Site, :count)
  end
end
