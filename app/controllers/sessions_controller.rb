class SessionsController < ApplicationController
  def new
  end

  def create
    customer = Customer.find_by! name: params[:customer_name]
    user = User.find_by! name: params[:user_name], customer: customer
    if user.authenticate(params[:user_password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "You are logged in!"
    else
      flash.now[:alert] = "Invalid login credentials."
      render :new
    end
  rescue ActiveRecord::RecordNotFound
    flash.now[:alert] = "Invalid login credentials."
    render :new
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You have been logged out."
  end
end
