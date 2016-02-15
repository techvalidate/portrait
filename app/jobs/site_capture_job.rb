require 'open3'

class SiteCaptureJob
  attr_accessor :site
  include Sidekiq::Worker


  def perform(site_id)
    @site = Site.find site_id
    # more solid error and exception handling could be implemented
    # by capturing two streams and exit status of command
    stdout, stdeerr, status = Open3.capture3(command)

    if status == 0 && File.exist?(site.tmp_image_file)
      site.attach(site.tmp_image_file)
    else
      site.failed!
    end
  end

  protected

  def command
    "phantomjs --ignore-ssl-errors=true #{Rails.root}/lib/rasterize.js #{site.url} #{site.tmp_image_file}"
  end

end