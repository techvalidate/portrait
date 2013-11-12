class ApplicationController < ActionController::Base

  protected
  def admin_required
    if current_user.nil? || !current_user.admin?
      flash[:warning] = "You must be an administrator to access that page."
      redirect_to root_path
    end
  end
end
