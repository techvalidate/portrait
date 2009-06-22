class SitesController < ApplicationController
  
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
    @site = Site.new params[:site]
    @site.save!
    render :xml=>@site.to_xml
  rescue ActiveRecord::RecordInvalid
    render :text=>@site.errors.to_xml, :status=>500
  end
  
end
