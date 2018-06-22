require 'rails_helper'

describe SitesController do
  before { login_as :jordan }

  it 'handles / with GET' do
    gt :sites
    expect(response).to be_success
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
      expect(response).to be_success
      expect(response).to render_template(:index)
    }.not_to change(Site, :count)
  end

  it 'handles / with valid parameters and POST' do
    expect {
      pst [:api, :sites], url: 'https://google.com'
      expect(assigns(:site).user).to eq(@user)
      expect(response).to be_success
      expect(response.body).to be_include("<image-url>/system/sites/images/000/000/002/original/2.png</image-url>")
      expect(response.body).to be_include("<format>png</format>")
      expect(response.body).to be_include('<selector nil="true"/>')
    }.to change(Site, :count).by(1)
  end

  it 'handles / with PDF and no selector and POST' do
    expect {
      pst [:api, :sites], url: 'https://google.com', format: 'pdf'
      expect(assigns(:site).user).to eq(@user)
      expect(response).to be_success
      expect(response.body).to be_include("<image-url>/system/sites/images/000/000/002/original/2.pdf</image-url>")
      expect(response.body).to be_include("<format>pdf</format>")
      expect(response.body).to be_include('<selector nil="true"/>')
    }.to change(Site, :count).by(1)
  end

  it 'handles / with PDF and selector and POST' do
    expect {
      pst [:api, :sites], url: 'https://google.com', format: 'pdf', selector: '#body'
      expect(assigns(:site).user).to eq(@user)
      expect(response).to be_success
      expect(response.body).to be_include("<image-url>/system/sites/images/000/000/002/original/2.pdf</image-url>")
      expect(response.body).to be_include("<format>pdf</format>")
      expect(response.body).to be_include("<selector>#body</selector>")
    }.to change(Site, :count).by(1)
  end

  it 'handles / with empty url and POST' do
    expect {
      pst [:api, :sites]
      expect(response.response_code).to eq(500)
      expect(response.body).to be_include("<error>Url is invalid</error>")
    }.not_to change(Site, :count)
  end

  it 'handles /sites with invalid url and POST' do
    expect {
      pst [:api, :sites], url: 'invalid'
      expect(response.response_code).to eq(500)
      expect(response.body).to be_include("<error>Url is invalid</error>")
    }.not_to change(Site, :count)
  end

end
