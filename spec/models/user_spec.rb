require 'rails_helper'

describe User, 'validations' do
  it 'should have a name' do
    user = User.new
    user.valid?
    expect(user.errors[:name]).not_to be_empty
  end

  it 'should have a name with valid characters' do
    user = User.new name: 'Invalid!'
    user.valid?
    expect(user.errors[:name]).not_to be_empty
  end

  it 'should have a password' do
    user = User.new
    user.valid?
    expect(user.errors[:password]).not_to be_empty
  end

  it 'should have a unique name per customer' do
    user = User.new name: users(:admin).name, customer: users(:admin).customer
    user.valid?
    expect(user.errors[:name]).not_to be_empty

    user = User.new name: users(:admin).name, customer: users(:different_admin).customer
    user.valid?
    expect(user.errors[:name]).to be_empty
  end
end
