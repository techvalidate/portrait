class UsersController < ApplicationController
  skip_before_action :admin_required, only: [:new, :forgot_password, :reset_forgotten_password]
  # GET /users
  def index
    @users = User.order('name')
    @user  = User.new
  end

  # GET /users/:id
  def show
    @user = User.find_by! name: params[:id]
  end

  def new
    @user = User.new
  end
  # POST /user
  def create
    @user = User.new params.require(:user).permit!
    @user.save!
    redirect_to users_url
  rescue ActiveRecord::RecordInvalid
    @users = User.order('name')
    render 'index'
  end

  # PUT /users/:id
  def update
    @user = User.find_by! name: params[:id]
    @user.update_attributes! params.require(:user).permit!
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    render 'show'
  end

  # DELETE /users/:id
  def destroy
    @user = User.find_by! name: params[:id]
    @user.destroy
    redirect_to users_url
  end
end
