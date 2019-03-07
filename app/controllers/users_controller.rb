class UsersController < ApplicationController
  # TODO I feel like there should be a more elegant way to express this before action
  # but I can't figure it out right now :(
  before_action do
    user_required(%w[index show].none?(action_name))
  end


  # GET /users
  def index
    @users = User.by_name_for_customer(@current_customer)
    @user  = User.new
  end

  # GET /users/:id
  def show
    @user = User.find_by! name: params[:id], customer: @current_customer
  rescue
    redirect_to users_url
  end

  # POST /user
  def create
    @user = User.new params.require(:user).permit!
    @user.customer = @current_user.customer
    @user.save!
    redirect_to users_url
  rescue ActiveRecord::RecordInvalid
    @users = User.by_name_for_customer(@current_customer)
    render :index
  end

  # PUT /users/:id
  def update
    @user = User.find_by! name: params[:id], customer: @current_customer
    @user.update_attributes! params.require(:user).permit!
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    render :show
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url
  end

  # DELETE /users/:id
  def destroy
    @user = User.find_by! name: params[:id], customer: @current_customer
    @user.destroy
    redirect_to users_url
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url
  end

end
