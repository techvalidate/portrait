class SitesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :api
  before_action  :authenticate_user!,  only: :api

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

  # POST /
  def api
    @site = current_user.sites.build url: params[:url]
    @site.save!
    render xml: @site.to_xml(only: [], methods: [:image_url])
  rescue ActiveRecord::RecordInvalid
    render xml: @site.errors.to_xml, status: 500
  end

end
