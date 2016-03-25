class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :admin_required

  protected
  def admin_required
    ##########################################
    # Admin access grants ability to manage  #
    # users and captured websites            #
    #########################################
    if !logged_in?
      store_location # Store destination to redirect after login
      redirect_to login_url
    end

    if logged_in? && !current_user.admin?
      log_out
      flash[:notice] = 'You do not have the right permissions'
      redirect_to root_url
    end
  end
  def user_required
    ###########################################
    # Use Basic HTTP for api reqs. Non admin  #
    # users only have api access              #
    ###########################################
    authenticate_or_request_with_http_basic do | username, password |
      @current_user = User.authenticate username, password
      @current_user
    end
  end
end
