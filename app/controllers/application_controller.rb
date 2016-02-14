class ApplicationController < ActionController::Base
  before_action :admin_required

  protected
  def admin_required
    authenticate_user!
    current_user && current_user.admin?
  end

end
