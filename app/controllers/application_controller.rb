class ApplicationController < ActionController::Base
  before_action :admin_required

  protected
  def admin_required
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = user(username, password)
      @current_user && @current_user.admin?
    end
  end

  def user_required
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = user(username, password)
      !@current_user.nil?
    end
  end

  # Check authentication and return User
  def user(username, password)
    user = User.find_by name: username
    user if user && user.authenticate(password)
  end

end
