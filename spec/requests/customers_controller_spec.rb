require 'rails_helper'

describe CustomersController do

  it 'handles /customers/new with valid params and POST' do
    expect {
      expect {
        pst :customers, customer: { name: 'new customer', users_attributes: { "0" => { name: 'admin', password: 'password'}}}
        expect(response).to redirect_to(root_url)
      }.to change(Customer, :count).by(1)
    }.to change(User, :count).by(1)
  end
end