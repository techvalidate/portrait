require 'rails_helper'

RSpec.describe 'Sites Controller', type: :request do
  let!(:user) {create(:user)}
  let!(:site) { create(:site, user_id: user.id) }
  let(:site_id) {site.id}
  let!(:sites) { create_list(:site, 10,user_id: user.id) }
  describe 'GET /sites' do
    #Make HTTP request before actually getting
    before { get '/sites' }

    it 'returns sites' do
      expect(sites).not_to be_empty
      expect(sites.size).to eq(10)
    end

  end

  describe 'GET /sites/:id' do
    before { get "/sites/#{site_id}" }
    context 'when the site exists' do
      it 'returns the site' do
        expect(site).to eq(site)
        expect(site.id).to eq(site_id)
      end
    end

    context 'when the site doesnot exist' do
      let(:site_id) {199}
      it 'doesnot return the site' do
        expect(site.id).to_not eq(site_id)
      end
    end
  end
  describe 'POST /todos' do
    let(:valid_attributes) { {id:1, url: 'www.eg.com'} }
    let(:site) {create(:site, id:1, url: 'www.eg.com', user_id: user.id )}

    context 'when the request is valid' do
      before { post '/sites', params: valid_attributes }

      it 'creates a site' do
        expect(site.url).to eq('www.eg.com')
        expect(site.id).to eq(1)
      end
    end

    context 'when the request is invalid' do
      before { post '/sites', params: { name: 'Name' } }

      it 'returns a validation failure message' do
        expect(response.status).to eq 302
      end
    end
  end

end

# require 'rails_helper'
#
# describe SitesController, 'html' do
#   before { login_as :admin }
#
#   it 'handles / with GET' do
#     gt :sites
#     expect(response).to be_successful
#   end
#
#   it 'handles /sites with valid parameters and POST' do
#     expect {
#       pst :sites, site: { url: 'https://google.com' }
#       expect(assigns(:site).site).to eq(@site)
#       expect(response).to redirect_to(sites_path)
#     }.to change(Site, :count).by(1)
#   end
#
#   it 'handles /sites with invalid url and POST' do
#     expect {
#       pst :sites, site: { url: 'invalid' }
#       expect(response).to redirect_to(sites_path)
#     }.not_to change(Site, :count)
#   end
# end
#
# describe SitesController, 'js api' do
#   before { login_as :admin }
#
#   it 'handles / with valid parameters and POST' do
#     expect {
#       pst :sites, site: { url: 'https://google.com' }, format: :json
#       expect(assigns(:site).site).to eq(@site)
#       expect(response).to be_successful
#       expect(response.body).to be_include('"status":"succeeded"')
#     }.to change(Site, :count).by(1)
#   end
#
#   it 'handles / with empty url and POST' do
#     expect {
#       pst :sites, format: :json
#       expect(response).to be_successful
#       expect(response.body).to be_include(':{"errors":{"url":["is invalid"]}}')
#     }.not_to change(Site, :count)
#   end
#
#   it 'handles /sites with invalid url and POST' do
#     expect {
#       pst :sites, site: { url: 'invalid' }, format: :json
#       expect(response).to be_successful
#       expect(response.body).to be_include(':{"errors":{"url":["is invalid"]}}')
#     }.not_to change(Site, :count)
#   end
#
# end
