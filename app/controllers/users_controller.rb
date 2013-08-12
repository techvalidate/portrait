class UsersController < ApplicationController
  
  # GET /users
  def index
    @users = User.order('name')
    @user  = User.new
  end
  
  # GET /users/:id
  def show
    @user = User.find_by_name! params[:id]
  end
  
  # POST /user
  def create
    @user = User.new params.require(:user).permit!
    @user.save!
    redirect_to users_url
  rescue ActiveRecord::RecordInvalid
    @users = User.order('name')
    render action: 'index'
  end
  
  # PUT /users/:id
  def update
    @user = User.find_by_name! params[:id]
    @user.update_attributes! params.require(:user).permit!
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    render action: 'show'
  end
  
  # DELETE /users/:id
  def destroy
    @user = User.find_by_name! params[:id]
    @user.destroy
    redirect_to users_url
  end
  
end
