require 'rails_helper'

describe User do
  let (:user) { users(:joe) }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it 'should have a name with valid characters' do
      invalid_names = ['INVALID', 'foo-bar09', 'Joe Plumber', 'joe09!']
      invalid_names.each do |invalid_name|
        user.name = invalid_name
        user.valid?
        expect(user.errors[:name]).not_to be_empty
      end
    end
  end

  context 'associations' do
    it { should have_many(:sites) }
  end
end
