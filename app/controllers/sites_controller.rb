class SitesController < ApplicationController
  
  # GET /
  def index
    @sites = Site.paginate :page=>params[:page]
  end
  
end
