class ImageCacheSearchService
  include Singleton

  TIME_FRAME = 1.day

  def self.run(site)
    time_range = (Time.zone.now - TIME_FRAME)...(Time.zone.now)
    Site
      .where(url: site.url, created_at: time_range)
      .where("id != #{site.id}")
      .order('created_at DESC')
      .limit(1)
      .first
  end

end
