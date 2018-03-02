json.site do
  if @site.persisted?
    json.partial! 'sites/site', site: @site
  else
    json.errors @site.errors
  end
end
