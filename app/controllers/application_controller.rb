class ApplicationController < ActionController::Base
  before_filter :admin_required
  
  protected
  def admin_required
    authenticate_or_request_with_http_basic do |username, password|
      @user = User.authenticate username, password
      @user && @user.admin?
    end
  end
  
  def user_required
    authenticate_or_request_with_http_basic do |username, password|
      @user = User.authenticate username, password
      !@user.nil?
    end
  end
  
end