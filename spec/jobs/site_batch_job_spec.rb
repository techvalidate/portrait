require 'rails_helper'

RSpec.describe SiteBatchJob, type: :job do
  context 'with an invalid url' do
    it 'still process valid urls' do
      site_batch = site_batches(:site_batch_with_invalid_site)
      SiteBatchJob.perform_now site_batch.id
      expect(site_batch.reload.status).to eq('completed')
      expect(site_batch.sites.pluck(:status).sort).to eq(['succeeded'])
    end
  end

  context 'with all valid urls' do
    it 'processes all urls' do
      site_batch = site_batches(:site_batch_valid_sites)
      SiteBatchJob.perform_now site_batch.id
      expect(site_batch.reload.status).to eq('completed')
      expect(site_batch.sites.pluck(:status).sort).to eq(['succeeded']*2)
    end
  end
end
