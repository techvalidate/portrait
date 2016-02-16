class Admin::BaseController < ApplicationController
  before_action :admin_required

  protected
  def admin_required
    authenticate_user!
    unless user_is_admin?
      redirect_to root_path, alert: 'You are not authorized to view this page'
    end
  end
end