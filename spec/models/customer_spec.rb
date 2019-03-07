require 'rails_helper'

describe Customer, 'validations' do
  it 'should have a name' do
    customer = Customer.new
    customer.valid?
    expect(customer.errors[:name]).not_to be_empty
  end

  it 'should have a name with valid characters' do
    customer = Customer.new name: "Invalid!"
    customer.valid?
    expect(customer.errors[:name]).not_to be_empty
    
    customer.name = "Valid"
    customer.valid?
    expect(customer.errors[:name]).to be_empty
  end

  it 'should have a unique name' do
    customer1 = Customer.first
    dup_customer = customer1.dup
    dup_customer.valid?
    expect(dup_customer.errors[:name]).not_to be_empty
  end

end