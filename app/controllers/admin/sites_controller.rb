class Admin::SitesController < Admin::BaseController

  # GET /sites
  def index
    @sites = Site.order(created_at: :desc).page params[:page]
    @site  = Site.new
  end

  # POST /sites
  def create
    @site = current_user.sites.build params.require(:site).permit(:url)
    @site.save!
    redirect_to admin_sites_url
  rescue ActiveRecord::RecordInvalid
    @sites = Site.order(created_at: :desc).page params[:page]
    render action: 'index'
  end

end
