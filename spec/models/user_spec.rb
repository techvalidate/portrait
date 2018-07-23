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
