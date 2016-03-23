require 'byebug'
class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :admin_required

  protected
  def admin_required
    # authenticate_or_request_with_http_basic do |username, password|
    #   @current_user = User.authenticate username, password
    #   @current_user && @current_user.admin?
    # end
    @admin_required = true

    if current_user.nil? || current_user.admin? == false
      store_location
      redirect_to login_url
    end
  end

  def user_required
    if current_user.nil
      redirect_to login_url
    end
  end

end
