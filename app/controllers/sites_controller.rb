class SitesController < ApplicationController
  before_action do 
    user_required(false)
  end

  def index
    @sites = @current_user.sites.order(created_at: :desc).page params[:page]
    @site  = Site.new
  end

  def create
    @site = @current_user.sites.build params.fetch(:site, {}).permit(:url)
    @site.save
    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json
    end
  end

end
