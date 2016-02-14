class UsersController < ApplicationController

  # GET /users
  def index
    @users = User.order('name')
    @user  = User.new
  end

  # GET /users/:id
  def show
    @user = User.find_by! name: params[:id]
  end

  # POST /user
  def create
    @user = User.new user_params
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

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

end
