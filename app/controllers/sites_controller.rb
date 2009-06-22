class SitesController < ApplicationController
  before_filter :authenticate, :except=>:api
  
  # GET /sites
  def index
    @sites = Site.paginate :page=>params[:page]
    @site  = Site.new
  end
  
  # POST /sites
  def create
    @site = Site.new params[:site]
    @site.save!
    redirect_to sites_path
  rescue ActiveRecord::RecordInvalid
    @sites = Site.paginate :page=>params[:page]
    render :action=>:index
  end
  
  # POST /
  def api
    @site = Site.new :url=>params[:url]
    @site.save!
    render :xml=>@site.to_xml
  rescue ActiveRecord::RecordInvalid
    render :text=>@site.errors.to_xml, :status=>500
  end
  
  protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      true
    end
  end
  
end
