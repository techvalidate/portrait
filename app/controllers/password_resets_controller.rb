class PasswordResetsController < ApplicationController
  skip_before_action :admin_required

  # GET /forgot_password
  def new
  end

  # POST /reset_password
  def create

    @user = User.find_by_email! params.require(:email)

    @user.send_password_reset

    flash[:success] = "Instructions to reset your password have been sent to #{@user.email}"
    redirect_to '/forgot_password'

  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'User with no such email could be found'
    redirect_to '/forgot_password'
  end

  def edit
    @user = User.find_by_password_reset_token! params.require(:id)
  rescue ActiveRecord::RecordNotFound
    redirect_to '/forgot_password', :notice => 'No such user'
  end

  def update
    @user = User.find_by_password_reset_token! params[:id]


    if @user.password_reset_sent_at < 1.hours.ago
      flash[:notice] = 'Password has expired'
      redirect_to login_url
    else
      @user.update_attributes! params.require(:user).permit!
      flash[:success] = 'Password has been reset'
      redirect_to login_url
    end

  rescue ActiveRecord::RecordInvalid
    redirect_to '/forgot_password', :notice => 'Password not updated'
  end

end

