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

  it 'should have a billing scheme' do
    customer = Customer.new
    customer.valid?
    expect(customer.errors[:billing_scheme]).not_to be_empty
  end
end

describe Customer, 'initialization' do
  it 'should have a default balance of zero' do
    customer = Customer.new
    expect(customer.balance).to eq(0)
  end
end

describe Customer, 'associations' do
  it 'can have zero users' do
    customer = Customer.create(name: 'customer', users: [])

    expect(customer.errors[:customers]).to be_empty
    expect(customer.users.count).to eq(0.0)
  end

  it 'can have many users' do
    users = [users(:jordan), users(:matt)]
    customer = Customer.create(name: 'customer', users: users,
                               billing_scheme: billing_schemes(:basic))

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

describe Customer, 'billing' do
  it 'should count this month based on usage' do
    expect(customers(:company).site_count_this_month).to eq(16)
  end

  it 'should count last month based on usage' do
    expect(customers(:company).site_count_last_month).to eq(4)
  end

  it 'should calculate this month billing based on usage' do
    expect(customers(:company).owed_this_month).to eq(0.63)
  end

  it 'should calculate last month billing based on usage' do
    expect(customers(:company).owed_last_month).to eq(0.20)
  end
end
