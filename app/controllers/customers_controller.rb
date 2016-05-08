class CustomersController < ApplicationController
  include UserHelper

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save && save_first_user(user_params, @customer)
      redirect_to "/"
    else
      flash[:warn] = @customer.errors.full_messages.join(". ")
      render 'new'
    end
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    @customer.canceled_at = DateTime.current if params[:cancel] && is_currently_active?
    @customer.reactivated_at = DateTime.current if !params[:cancel] && is_currently_canceled?
    if @customer.update(customer_params)
      redirect_to '/'
    else
      flash[:warn] = @customer.errors.full_messages.join(". ")
      render 'edit'
    end
  end

  def delete
  end

  private
  def customer_params
    params.require(:customer).permit(:name)
  end

  def user_params
    params[:user] = params[:customer][:user]
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end