class ApplicationController < ActionController::Base

  protect_from_forgery unless: -> { request.format.json? }

  protected
  def admin_required
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = User.authenticate username, password
      @current_user&.admin?
    end
  end

  def user_required
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = User.authenticate username, password
      @current_user.present?
    end
  end

end
