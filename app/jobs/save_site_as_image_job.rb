class SaveSiteAsImageJob < ApplicationJob
  queue_as :default

  def perform(site)
    png_path = generate_png site
    handle png_path, site
  end

  # Set the png located at path to the image
  def handle(path, site)
    File.exist?(path) ? site.attach(path) : site.failed!
  end

  def attach(path, site)
    site.image.attach io: File.open(path), filename: "#{site.id}.png", content_type: 'image/png'
    succeeded!
  ensure
    FileUtils.rm path
  end

  def generate_png(site)
    node      = `which node`.chomp
    file_name = "#{site.id}-full.png"
    command   = "#{node} #{Rails.root}/app/javascript/puppeteer/generate_screenshot.js --url='#{url}' --fullPage=true --omitBackground=true --savePath='#{Rails.root}/tmp/' --fileName='#{file_name}'"

    system command

    return "#{Rails.root}/tmp/#{file_name}"
  end
end
