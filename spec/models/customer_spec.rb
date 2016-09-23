require 'rails_helper'

describe Customer, 'validations' do
  it 'should have a name' do
    customer = Customer.new
    customer.valid?
    expect(customer.errors[:name]).not_to be_empty
  end

  it 'should have a name with valid characters' do
    customer = Customer.new name: ')(*^)'
    customer.valid?
    expect(customer.errors[:name]).not_to be_empty
  end

  it 'should have a unique name' do
    customer = Customer.new name: customers(:company).name
    customer.valid?
    expect(customer.errors[:name]).not_to be_empty
  end
end

describe Customer, 'associations' do
  it 'can have zero users' do
    customer = Customer.create(name: 'customer', users: [])

    expect(customer.errors[:customers]).to be_empty
    expect(customer.users.count).to eq(0)
  end

  it 'can have many users' do
    users = [users(:jordan), users(:matt)]
    customer = Customer.create(name: 'customer', users: users)

    expect(customer.errors[:customers]).to be_empty
    expect(customer.users.count).to eq(users.count)
  end

  it 'should remove users on customer removal' do
    users = [users(:jordan), users(:matt)]
    customer = Customer.create(users: users)

    expect { customer.destroy }.to change{User.count}.from(users.count).to(0)
  end
end

describe Customer, 'status' do
  it 'should be active by default' do
    customer = Customer.create(name: 'customer')

    expect(customer.active?).to be(true)
  end

  it 'can be canceled at any time' do
    customer = Customer.create(name: 'customer')

    customer.cancel!

    expect(customer.canceled?).to be(true)
  end
end
