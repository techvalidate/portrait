class SitesController < ApplicationController
  before_action :authorize

  def index
    # @sites = Site.all
    @sites = current_user.sites.order(created_at: :desc)
    # @site  = Site.new
  end


  def create
    @site = @current_user.sites.new(site_params)
    if(@site.save)

      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_path(@current_user.id)
    else
      render 'index'
    end





    # @site = @current_user.sites.build params.fetch(:site, {}).permit(:url)
    # @site.save
    # respond_to do |format|
    #   format.html { redirect_to sites_url }
    #   format.json
    # end
  end

  private
  def site_params
    params.permit(:url)
  end

end
