class SaveSiteAsImageJob < ApplicationJob
  queue_as :default

  def perform(site_id)
    site = Site.find(site_id)
    existing_site = ImageCacheSearchService.run(site)
    if existing_site&.image.present?
      # TODO: not DRY - really need a attach image service
      tmp_file_path = Rails.root.to_s + '/tmp/temporary-' + existing_site.id.to_s


      # NOTE:  DOES NOT WORK yet.... I think I'm close, but I'm new to ActiveStorage and stuggled here.  Ran up against my time limit.
      File.open(tmp_file_path, 'w') { |file| file.write(existing_site.image.blob) }

      # NOTE: trying to use the `download` method from ActiveStorage brought up some encodign errors
      #       that was my clue to give up for the day :)
      # File.open(tmp_file_path, 'w') { |file| file.write(existing_site.image.blob.download) }

      site.image.attach io: File.open(tmp_file_path), filename: "#{site.id}.png", content_type: 'image/png'
      site.succeeded!
      return
    end
    res = SaveSiteAsImageService.run(site)
    res ? site.succeeded! : site.failed!
  end

end
