class CustomersController < ApplicationController
  before_action :set_billing_schemes, only: [:index, :show, :create, :update]

  # GET /customers
  def index
    @customers = Customer.order('name')
    @customer  = Customer.new

    fields = %i(site_count_this_month site_count_last_month owed_this_month
                owed_last_month balance)
    @totals = Hash[fields.collect { |f| [f, Customer.send(f) ] }]
  end

  # GET /customers/:id
  def show
    @customer = Customer.find_by! name: params[:id]
  end

  # POST /customer
  def create
    @customer = Customer.new params.require(:customer).permit!
    @customer.save!
    redirect_to customers_url
  rescue ActiveRecord::RecordInvalid
    @customers = Customer.order('name')
    render 'index'
  end

  # PUT /customers/:id
  def update
    @customer = Customer.find_by! name: params[:id]
    @customer.update_attributes! params.require(:customer).permit!
    redirect_to @customer
  rescue ActiveRecord::RecordInvalid
    render 'show'
  end

  # POST /customers/:id/cancel
  def cancel
    @customer = Customer.find_by! name: params[:id]
    @customer.cancel!
    redirect_to customers_url
  end

  # POST /customers/:id/bill
  def bill
    @customer = Customer.find_by! name: params[:id]
    @customer.bill_last_month!
    redirect_to customers_url
  end

  # DELETE /customers/:id
  def destroy
    @customer = Customer.find_by! name: params[:id]
    @customer.destroy
    redirect_to customers_url
  end

  protected

  def set_billing_schemes
    @billing_schemes = BillingScheme.all
  end
end