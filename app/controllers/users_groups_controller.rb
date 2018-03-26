class UsersGroupsController < ApplicationController
  before_action :user_required
  before_action :user_authorized, except: [:show, :update]

  def create
    group = Group.find_by(id: user_group_params[:group_id])
    user = User.find_by(id: user_group_params[:user_id])

    flash[:notice] = "User successfully added!" if user.groups << group
    redirect_to group_path(group)
  end

  def destroy
    group = Group.find_by(id: user_group_params[:group_id])
    ug = UsersGroup.find_by(
      user_id: user_group_params[:user_id],
      group_id: user_group_params[:group_id],
      deleted_at: nil
    )
    ug.deleted_at = Time.now

    if ug.save
      flash[:notice] = "User successfully removed."
    end

    redirect_to group_path(group)
  end

  private
  def user_group_params
    params.permit(:user_id, :group_id)
  end

  def user_authorized
    redirect_to root_path unless @current_user.admin?
  end
end
