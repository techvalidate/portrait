require 'rails_helper'

describe User, 'validations' do
  it 'should have a name' do
    user = User.new
    user.valid?
    expect(user.errors[:name]).not_to be_empty
  end

  it 'should have a name with valid characters' do
    user = User.new name: 'INVALID'
    user.valid?
    expect(user.errors[:name]).not_to be_empty
  end

  it 'should have a unique name' do
    user = User.new name: users(:jordan).name
    user.valid?
    expect(user.errors[:name]).not_to be_empty
  end
end
