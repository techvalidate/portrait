class SessionsController < ApplicationController
  skip_before_action :admin_required


  def new
  end

  def create
    allowed_params = params.permit(session: [:name, :password])
    user = User.find_by! name: allowed_params[:session][:name]

    if user && user.authenticate(allowed_params[:session][:password])
      log_in user
      redirect_back_or user
    else
      flash[:notice] = 'Invalid username or password'
      render 'new'
    end

  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'Invalid username or password'
    redirect_to login_path
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
