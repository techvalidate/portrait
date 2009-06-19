class SitesController < ApplicationController
  
  # GET /
  def index
    @sites = Site.paginate :page=>params[:page]
  end
  
  # POST /sites
  def create
    @site = Site.new params[:site]
    @site.save!
    redirect_to sites_path
  end
  
end
