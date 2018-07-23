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