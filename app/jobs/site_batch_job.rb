class SiteBatchJob < ApplicationJob
  queue_as :default

  def perform(site_batch_id)
    @site_batch = SiteBatch.find(site_batch_id)
    @site_batch.started!
    process_sites
    @site_batch.completed!
  end

  private

  def process_sites
    @site_batch.submitted_urls.each do |url|
      begin
        Site.create(user: @site_batch.user, url: url, site_batch: @site_batch).process!
      rescue
        next
      end
    end
  end
end
