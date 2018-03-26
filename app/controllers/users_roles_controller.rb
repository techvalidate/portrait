class UsersRolesController < ApplicationController
  before_action :user_required
  before_action :user_authorized, except: [:show, :update]

  def create
    role = Role.find_by(id: user_role_params[:role_id])
    user = User.find_by(id: user_role_params[:user_id])

    flash[:notice] = "User successfully added!" if user.roles << role
    redirect_to role_path(role)
  end

  def destroy
    role = Role.find_by(id: user_role_params[:role_id])
    ur = UsersRole.find_by(
      user_id: user_role_params[:user_id],
      role_id: user_role_params[:role_id],
      deleted_at: nil
    )
    ur.deleted_at = Time.now

    if ur.save
      flash[:notice] = "User successfully removed."
    end

    redirect_to role_path(role)
  end

  private
  def user_role_params
    params.permit(:user_id, :role_id)
  end

  def user_authorized
    redirect_to root_path unless @current_user.admin?
  end
end
