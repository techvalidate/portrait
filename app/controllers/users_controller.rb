class UsersController < ApplicationController
  include UserHelper

  before_action :admin_required
  before_action :get_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = customer_users
    @user  = User.new
  end

  # GET /users/:id
  def show
  end

  # POST /user
  def create
    @user = User.new params.require(:user).permit!
    @user.customer = current_customer
    @user.save!
    redirect_to users_url
  rescue ActiveRecord::RecordInvalid
    errors = @user.errors.full_messages
    flash[:warn] = errors.join(". ")
    @users = customer_users
    render 'index'
  end

  # PUT /users/:id
  def update
    @user.skip_password_validation = password_exists?
    @user.update_attributes! params.require(:user).permit!
    redirect_to users_path
  rescue ActiveRecord::RecordInvalid
    errors = @user.errors.full_messages
    flash[:warn] = errors.join(". ")
    render 'show'
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    redirect_to users_url
  end

  private

  def get_user
    @user ||= User.find_by(name: params[:id], customer_id: current_customer.id)
  end

  def password_exists?
    @user.password_digest && !(params[:user][:password] || params[:user][:password_confirmation])
  end

end
