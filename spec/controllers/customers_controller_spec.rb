require 'rails_helper'

describe CustomersController do
  before { login_as :jordan }

  it 'handles /customers with GET' do
    get :index
    expect(response).to be_success
  end

  it 'handles /customers/:id with GET' do
    get :show, id: customers(:company)
    expect(response).to be_success
  end

  it 'handles /customers with valid params and POST' do
    expect {
      post :create, customer: { name: 'name',
                                billing_scheme_id: billing_schemes(:basic).id }
      expect(response).to redirect_to(customers_path)
    }.to change(Customer, :count).by(1)
  end

  it 'handles /customers/:id with valid params and PUT' do
    customer = customers(:company)
    put :update, id: customer.to_param, customer: { name: 'new' }
    expect(customer.reload.name).to eq('new')
    expect(response).to redirect_to(customer_path(customer))
  end

  it 'handles /customers/:id with invalid params and PUT' do
    customer = customers(:company)
    put :update, id: customer.to_param, customer: { name: '~<>' }
    expect(response).to be_success
    expect(response).to render_template(:show)
  end

  it 'handles /customers/:id with DELETE' do
    expect {
      delete :destroy, id: customers(:company)
      expect(response).to redirect_to(customers_path)
    }.to change(Customer, :count).by(-1)
  end

  it 'handles /customers/:id/cancel with POST' do
    customer = customers(:company)
    post :cancel, id: customer
    expect(customer.reload.canceled?).to be true
    expect(response).to redirect_to(customers_path)
  end

  it 'handles /customers/:id/bill with POST' do
    customer = customers(:company)
    post :bill, id: customer
    expect(customer.reload.balance).to eq(0.20)
    expect(response).to redirect_to(customers_path)
  end
end