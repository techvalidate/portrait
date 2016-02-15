class SitesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :api
  before_action  :authenticate_user!,  only: :api

  # POST /
  def api
    @site = current_user.sites.build url: params[:url]
    @site.save!
    render xml: @site.to_xml(only: [], methods: [:image_url])
  rescue ActiveRecord::RecordInvalid
    render xml: @site.errors.to_xml, status: 500
  end

end
