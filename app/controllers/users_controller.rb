class UsersController < ApplicationController
  before_filter :admin_required, except: [:new, :forgot_password, :reset_password]
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

  #GET /forgot_password
  def forgot_password
  end
  # POST /reset_password
  def reset_password
    @user = User.find_by! name: params[:name]['name']

    if @user.email == params[:email]['email']

      random_password = User.generate_random_password
      @user.password = random_password
      @user.save!
      UserMailer.create_and_send_password_change(@user, random_password).deliver_now
      redirect_to root_url

    else
      redirect_to root_url
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
  end

end
