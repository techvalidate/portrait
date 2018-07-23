require 'rails_helper'

RSpec.describe Site, type: :model do
  let!(:user) {create(:user)}
  let!(:site) { create(:site, user_id: user.id)}

  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:user_id) }

  it {should belong_to(:user)}

  describe Site, 'validity' do
    it "is valid with valid attributes" do
      expect(site).to be_valid
    end

  end


end
#
# describe Site do
#   it 'should belong to a user' do
#     expect(sites(:google).user).to eq(users(:admin))
#   end
#
#   it 'should require a url' do
#     site = Site.new
#     site.valid?
#     expect(site.errors[:url]).not_to be_empty
#   end
#
#   it 'should require a valid url' do
#     site = Site.new url: 'invalid'
#     site.valid?
#     expect(site.errors[:url]).not_to be_empty
#   end
#
#   it 'should require a user' do
#     site = Site.new
#     site.valid?
#     expect(site.errors[:user_id]).not_to be_empty
#   end
# end
