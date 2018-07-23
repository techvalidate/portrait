class UsersController < ApplicationController
  before_action :authorize, except: :new

  # GET /users
  def index
    @users = User.by_name
    @user  = User.new
  end

  def new
    @user = User.new
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # POST /user
  def create

    @user = User.new(user_params)
    if(@user.save)
      log_in @user

      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_path(@user.id)
    else
      render 'new'
    end

  #   @user = User.new params.require(:user).permit!
  #   @user.save!
  #   redirect_to users_url
  # rescue ActiveRecord::RecordInvalid
  #   @users = User.by_name
  #   render :index
  end

  # PUT /users/:id
  def update
    @user = User.find_by! name: params[:id]
    @user.update_attributes! params.require(:user).permit!
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    render :show
  end

  # DELETE /users/:id
  def destroy
    @user = User.find_by! name: params[:id]
    @user.destroy
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
