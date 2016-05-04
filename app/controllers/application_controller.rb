require 'digest'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  protected

  def user_required
    redirect_to '/login' unless current_user
  end

  def admin_required
    unless current_user && current_user.admin?
      flash[:notice] = "Admin rights are required here."
      redirect_to '/login'
    end
  end

end
