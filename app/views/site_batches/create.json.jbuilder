json.site_batch do
  if @site_batch.persisted?
    json.id @site_batch.id
    json.status @site_batch.status
    json.submitted_urls @site_batch.submitted_urls
  else
    json.errors @site_batch.errors
  end
end
