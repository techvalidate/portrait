class SitesController < ApplicationController
  
  # GET /
  def index
    @sites = Site.paginate :page=>params[:page]
    @site  = Site.new
  end
  
  # POST /sites
  def create
    @site = Site.new params[:site]
    @site.save!
    respond_to do |format|
      format.html { redirect_to sites_path    }
      format.xml  { render :xml=>@site.to_xml }
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.html do
        @sites = Site.paginate :page=>params[:page]
        render :index
      end
      format.xml { render :text=>@site.errors.to_xml, :status=>500 }
    end

  end
  
end
