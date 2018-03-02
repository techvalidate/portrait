require 'rails_helper'

RSpec.describe SiteBatchesController, type: :request do
  before { login_as :admin }

  context 'for json requests' do
    context 'to #create with POST' do
      it 'creates a new SiteBatch' do
        expect{
          pst :site_batches, site_batch: { submitted_urls: ['https://www.google.com'] }, format: :json
          expect(response).to be_successful
        }.to change(SiteBatch, :count).by(1)
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
    end
  end
end
