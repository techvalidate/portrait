require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  context 'authentication' do
    it 'is tested by Devise and does not need to be validated here.'
  end

  context 'validations' do
    it 'should have an email' do
      User.new.should have(1).error_on(:email)
    end

    it 'should have a name with valid characters' do
      User.new(email: 'INVALID').should have(1).error_on(:email)
    end

    it 'should have a password' do
      User.new.should have(1).error_on(:password)
    end

    it 'should have a unique email' do
      FactoryGirl.create(:user, :email => 'test@example.com')
      User.new(email: 'test@example.com').should have(1).error_on(:email)
    end
  end
end
