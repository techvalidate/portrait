class CustomersController < ApplicationController

  def new
    @customer = Customer.new
    @customer.users.build
  end

  def create
    @customer = Customer.new params.require(:customer).permit!
    @customer.status = Customer.statuses[:active]
    @customer.save!
    redirect_to root_url
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    # TODO
  end

end