class SitesController < ApplicationController
  before_filter      :authenticate_user!, :except => :api
  before_filter      :admin_required,     :except => :api

  before_filter      :authenticate_api, :only => :api

  # GET /sites
  def index
    @sites = Site.order('created_at DESC').page params[:page]
    @site  = Site.new
  end

  # POST /sites
  def create
    @site = current_user.sites.build params.require(:site).permit(:url)
    @site.save!
    redirect_to sites_url
  rescue ActiveRecord::RecordInvalid
    @sites = Site.order('created_at DESC').page params[:page]
    render action: 'index'
  end

  # POST /
  def api
    @site = @api_user.sites.build url: params[:url]
    @site.save!
    render xml: @site.to_xml(only: [:state], methods: [:image_url])
  rescue ActiveRecord::RecordInvalid
    render xml: @site.errors.to_xml, status: 500
  end

  private
  def authenticate_api
    email    = params[:email]
    password = params[:password]

    if email.nil?
      error = [:email, "is nil"]
      raise
    end

    if password.nil?
      error = [:password, "is nil"]
      raise
    end

    if !@api_user = User.find_by_email(email.downcase)
      error = [:email, "not found"]
      raise
    end

    if !@api_user.valid_password?(password)
      # Consider not reporting invalid passwords. This allows crackers
      # feedback to a dictionary attack, etc...
      error = [:password, "Invalid"]
      raise
    end

  rescue
    # I've used the following pattern for consistency with api's error messages.
    # Ultimately, I think creating an APIException class would be best.
    errors = ActiveModel::Errors.new(User.new)
    errors.add(*error)
    render xml: errors.to_xml, status: 500 and return
  end
end
