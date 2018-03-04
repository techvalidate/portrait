require 'rails_helper'

RSpec.describe SiteBatchesController, type: :request do
  before { login_as :admin }

  context 'for json requests' do
    context 'to #create with POST' do
      it 'creates a new SiteBatch' do
        expect{
          pst :site_batches, site_batch: { submitted_urls: ['https://www.google.com'] }, format: :json
          expect(response).to be_successful
        }.to change(@user.site_batches, :count).by(1)
      end

      it 'creates a job to process the site batch' do
        expect{
          pst :site_batches, site_batch: { submitted_urls: ['https://www.google.com', 'https://www.yahoo.com'] }, format: :json
          expect(response).to be_successful
        }.to change(Delayed::Job, :count).by(1)
      end

      it 'returns the SiteBatch id and status' do
        pst :site_batches, site_batch: { submitted_urls: ['https://www.google.com'] }, format: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)['site_batch']).to include('id')
      end

      it 'returns an error if submitted_urls is empty' do
        pst :site_batches, site_batch: { submitted_urls: [] }, format: :json
        expect(response).to be_successful
        expect(response.body).to be_include(':{"errors":{"submitted_urls":["can\'t be blank"]}}')
      end

      it 'returns an error if submitted_urls is null' do
        pst :site_batches, site_batch: { submitted_urls: nil }, format: :json
        expect(response).to be_successful
        expect(response.body).to be_include(':{"errors":{"submitted_urls":["can\'t be blank"]}}')
      end
    end

    context 'to #show with GET' do
      before do
        @site_batch = site_batches(:site_batch_with_invalid_site)
        @site_batch.sites << sites(:google)
      end

      it 'returns the site batch and generated sites' do
        gt @site_batch, format: :json
        expect(response).to be_successful
        site_batch_json = JSON.parse(response.body)
        expect(site_batch_json['site_batch']).to include('sites')
        expect(site_batch_json['site_batch']).to include('id')
      end

      it 'returns 404 if requesting a batch for another user' do
        login_as :user
        gt @site_batch, format: :json
        expect(response.status).to eq(404)
        expect(response.body).to eq('{"errors":"not found"}')
      end
    end
  end
end
