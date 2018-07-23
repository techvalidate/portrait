class ApplicationController < ActionController::Base

  protect_from_forgery unless: -> { request.format.json? }
  protect_from_forgery with: :exception
  include SessionsHelper


  def authorize

    unless current_user
      redirect_to login_path, alert: 'You must be logged in to access that page.'
    end
  end

  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end

  # protected

  # def user_required
  #   authenticate_or_request_with_http_basic do |username, password|
  #     @current_user = User.authenticate username, password
  #     @current_user.present?
  #   end
  # end



end
