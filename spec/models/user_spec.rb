require 'rails_helper'

describe User, 'validations' do
  it 'should have a name' do
    user = User.new
    user.valid?
    expect(user.errors[:name]).not_to be_empty
  end

  it 'should have a password' do
    user = User.new
    user.valid?
    expect(user.errors[:password]).not_to be_empty
  end

  it 'should have a unique name' do
    user = User.new({name: users(:jordan).name, customer_id: users(:jordan).customer_id})
    user.valid?
    expect(user.errors[:name]).not_to be_empty
  end
end
