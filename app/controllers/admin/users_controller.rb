class Admin::UsersController < Admin::BaseController

  # GET /users
  def index
    @users = User.order('name')
    @user  = User.new
  end

  # GET /users/:id
  def show
    @user = User.find_by! name: params[:id]
  end

  # PUT /users/:id
  def update
    @user = User.find_by! name: params[:id]
    @user.update_attributes! user_params
    redirect_to [:admin, @user]
  rescue ActiveRecord::RecordInvalid
    render 'show'
  end

  # DELETE /users/:id
  def destroy
    @user = User.find_by! name: params[:id]
    @user.destroy
    redirect_to admin_users_url
  end

  def user_params
    params.require(:user).permit(:email, :name, :admin)
  end

end
