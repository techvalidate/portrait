class SessionsController < ApplicationController
  skip_before_action :admin_required, except: [:destroy]

  # GET sessions/new
  def new
  end

  # POST sessions/create
  def create
    allowed_params = params.require(:session).permit!
    user = User.find_by! name: allowed_params[:name]

    if User.authenticate(user.name, allowed_params[:password])
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

  # DELETE sessions/destroy
  def destroy
    log_out
    redirect_to root_url
  end
end
