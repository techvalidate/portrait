class SessionsController < ApplicationController
  before_filter :admin_required, except: [:new, :create]
  def new
  end

  def create
    user = User.find_by! name: params[:session][:name]

    if user && user.authenticate(params[:session][:password])
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
