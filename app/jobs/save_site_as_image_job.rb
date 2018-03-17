class SaveSiteAsImageJob < ApplicationJob
  queue_as :default

  def perform(site_id)
    site = Site.find(site_id)
    site.started!
    #  TODO: cache search
    res = SaveSiteAsImageService.run(site)
    res ? site.succeeded! : site.failed!
  end

end
