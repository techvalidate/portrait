class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :user_is_admin?

  protected

  def user_is_admin?
    current_user && current_user.admin?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)        << [:name]
    devise_parameter_sanitizer.for(:account_update) << [:name]
  end
end
