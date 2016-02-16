class SitesController < ApplicationController
  before_action  :authenticate_user!

  def index
    @sites = current_user.sites.paginate page: params[:page] || 1, per_page: 30
  end

  def show
    @site = current_user.sites.find(params[:id])
    if @site
      send_file @site.image.path
    else
      redirect_to sites_path, error: "You are not authorized to view this site"
    end
  end

end
