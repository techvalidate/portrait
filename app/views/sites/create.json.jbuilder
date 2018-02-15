json.site do
  if @site.persisted?
    json.id @site.id
    json.status @site.status

    if @site.image.attached?
      json.image do
        json.url url_for(@site.image)
      end
    end

  else
    json.errors @site.errors
  end
end
