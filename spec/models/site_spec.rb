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
