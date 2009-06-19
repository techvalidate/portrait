class SitesController < ApplicationController
  
  # GET /
  def index
    @sites = Site.all
  end
  
end
