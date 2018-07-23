require 'rails_helper'
RSpec.describe User, type: :model do
  let!(:user) { create(:user)}

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it {should have_many(:sites).dependent(:destroy) }

  describe User, 'validity' do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

  end


end
# describe User, 'authentication' do
#   it 'should be a valid user' do
#     user = User.new(email: 'admin@admin.com', password_digest: 'password')
#     expect(user).to be_valid
#   end
#
#   it 'should not authenticate valid user with wrong password' do
#     user = User.new email: nil, password_digest: 'password'
#     expect(user).to_not be_valid
#   end
#
#   it 'should not authenticate valid user with nil password' do
#     expect(User.authenticate('admin', nil)).to be_nil
#   end
#
#   it 'should not authenticate with invalid user name' do
#     expect(User.authenticate('invalid', 'anything')).to be_nil
#   end
#
#   it 'should not authenticate with nil user name' do
#     expect(User.authenticate(nil, nil)).to be_nil
#   end
# end
#
# describe User, 'validations' do
#   it 'should have a name' do
#     user = User.new
#     user.valid?
#     expect(user.errors[:name]).not_to be_empty
#   end
#
#   it 'should have a name with valid characters' do
#     user = User.new name: 'INVALID'
#     user.valid?
#     expect(user.errors[:name]).not_to be_empty
#   end
#
#   it 'should have a password' do
#     user = User.new
#     user.valid?
#     expect(user.errors[:password]).not_to be_empty
#   end
#
#   it 'should have a unique name' do
#     user = User.new name: users(:admin).name
#     user.valid?
#     expect(user.errors[:name]).not_to be_empty
#   end
# end
