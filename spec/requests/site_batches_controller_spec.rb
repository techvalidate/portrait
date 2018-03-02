require 'rails_helper'

RSpec.describe SiteBatchesController, type: :request do
  before { login_as :admin }

  context 'for json requests' do
    it 'creates a new SiteBatch for POST to #create' do
      expect{
        pst :site_batches, site_batch: { submitted_urls: ['https://www.google.com'] }, format: :json
      }.to change(SiteBatch, :count).by(1)
    end

    it 'creates a job for each url submitted' do
      expect{
        pst :site_batches, site_batch: { submitted_urls: ['https://www.google.com', 'https://www.yahoo.com'] }, format: :json
      }.to change(Delayed::Job, :count).by(2)
    end
  end
end
