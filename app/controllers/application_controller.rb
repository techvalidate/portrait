class ApplicationController < ActionController::Base

  protect_from_forgery unless: -> { request.format.json? }

  helper_method :current_user

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

  def user_required(admin_required)
    unless current_user
      flash[:error] = "Please login to access this feature."
      redirect_to sessions_new_url
    end
    admin_check if admin_required
  end

  def XXXuser_required(admin_required)
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = User.authenticate username, password
      @current_customer = @current_user.customer
      @current_user.present?
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
