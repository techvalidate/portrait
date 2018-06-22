class SitesController < ApplicationController
  before_action :user_required,    only: :api
  before_action :admin_required, except: :api

  # GET /sites
  def index
    @sites = Site.order(created_at: :desc).page params[:page]
    @site  = Site.new
  end

  # POST /sites
  def create
    @site = @current_user.sites.build params.require(:site).permit(:url, :format)
    @site.save!
    redirect_to sites_url
  rescue ActiveRecord::RecordInvalid
    @sites = Site.order(created_at: :desc).page params[:page]
    render action: 'index'
  end

  # POST /
  def api
    @site = @current_user.sites.build url: params[:url]
    @site.save!
    render xml: @site.to_xml(only: [], methods: [:image_url])
  rescue ActiveRecord::RecordInvalid
    render xml: @site.errors.to_xml, status: 500
  end

end
