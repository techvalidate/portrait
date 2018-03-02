json.site_batch do
  json.id @site_batch.id
  json.status @site_batch.status
  json.submitted_urls @site_batch.submitted_urls
  json.sites @site_batch.sites, partial: 'sites/site', as: :site
end
