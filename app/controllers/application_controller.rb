class ApplicationController < ActionController::Base

  protect_from_forgery unless: -> { request.format.json? }

  helper_method :current_user, :current_customer

  protected

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
      @current_customer ||= @current_user.customer if @current_user
    else
      @current_user = nil
    end
    @current_user
  end

  def current_customer
    current_user ? current_user.customer : nil
  end

  def user_required(admin_required)
    unless current_user
      flash[:error] = "Please login to access this feature."
      redirect_to sessions_new_url
    end
    admin_check if admin_required
  end

  def admin_check
    unless @current_user.admin?
      flash[:error] = "You must be an admin to access this feature"
      redirect_to users_url
    end
  end

end
