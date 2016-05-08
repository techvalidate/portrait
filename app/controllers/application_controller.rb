class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_customer
    @current_customer ||= current_user.customer if current_user
  end

  def is_currently_canceled?
    current_customer.canceled_at && (current_customer.reactivated_at.nil? || current_customer.canceled_at > current_customer.reactivated_at)
  end

  def is_currently_active?
    current_customer.canceled_at.nil? || current_customer.canceled_at < current_customer.reactivated_at
  end

  helper_method :current_user, :current_customer, :is_currently_active?, :is_currently_canceled?

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
