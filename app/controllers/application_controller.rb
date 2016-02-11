class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_filter :admin_required

  protected
  def admin_required
    current_user && current_user.admin?
  end
end