class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_required

  # GET /users
  def index
    @users = User.order('email')
  end

  # GET /users/:id
  def show
    @user = User.find params[:id]
  rescue ActiveRecord::RecordNotFound
    rescue_record_not_found(params[:id])
  end

  # POST /user
  def create
    @user = User.new params.require(:user).permit!
    @user.save!
    redirect_to users_url
  rescue ActiveRecord::RecordInvalid
    @users = User.order('email')
    render action: 'index'
  end

  # PUT /users/:id
  def update
    # I've used find because throwing and rescuing exceptions seems to be the
    # style this controller is developed in.
    # Another option here is to use find_by_id and check if the return is false.
    @user = User.find params[:id]
    @user.update_attributes! params.require(:user).permit!
    redirect_to @user
  rescue ActiveRecord::RecordNotFound
    rescue_record_not_found(params[:id])
  rescue ActiveRecord::RecordInvalid
    render action: 'show'
  end

  # DELETE /users/:id
  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to users_url
  rescue ActiveRecord::RecordNotFound
    rescue_record_not_found(params[:id])
  end

  private
  def rescue_record_not_found(id)
    flash[:warning] = "Count not find user with ID: #{id}"
    @user = User.new
    @users = User.order('email')
    render action: 'index'
  end
end
