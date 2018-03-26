class ApplicationController < ActionController::Base

  protect_from_forgery unless: -> { request.format.json? }

  protected

  def user_required
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = User.authenticate username, password
      session[:user_id] = @current_user.id if @current_user
      @current_user.present?
    end
  end

end
