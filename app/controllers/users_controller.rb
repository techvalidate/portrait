class UsersController < ApplicationController
  before_action :user_required
  before_action :user_authorized, except: [:show, :update]

  # GET /users
  def index
    @users = User.by_name.map { |u| UserPresenter.new(u) }
    @user  = User.new
  end

  # GET /users/:id
  def show
    @user = UserPresenter.new User.find_by! name: params[:id]
  end

  # POST /user
  def create
    @user = User.new permitted_params
    @user.save!
    redirect_to users_url
  rescue ActiveRecord::RecordInvalid
    @users = User.by_name
    render :index
  end

  # PUT /users/:id
  def update
    @user = User.find_by! name: params[:id]

    if permitted_params[:password].blank?
      @user.errors.add(:password, 'can not be nil')
      raise ActiveRecord::RecordInvalid
    end

    @user.update_attributes! permitted_params
    flash[:notice] = "Successfully updated"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = @user.errors.full_messages.join(". ")
    @user = UserPresenter.new @user
    render :show
  end

  # DELETE /users/:id
  def destroy
    @user = User.find_by! name: params[:id]
    @user.destroy
    redirect_to users_url
  end

  private

  def permitted_params
    params.require(:user).permit(:name, :email, :password)
  end

  def user_authorized
    redirect_to root_path unless @current_user.admin?
  end

end
