class ApplicationController < ActionController::Base

  protect_from_forgery unless: -> { request.format.json? }
  protect_from_forgery with: :exception
  include SessionsHelper


  def authorize

    unless current_user
      redirect_to login_path, alert: 'You must be logged in to access that page.'
    end
  end

end
