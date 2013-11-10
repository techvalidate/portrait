require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  context 'authentication' do
    it 'should authenticate a valid user' do
      User.authenticate(admin.name, admin.password).should == admin
    end

    it 'should not authenticate valid user with wrong password' do
      User.authenticate('jordan', 'wrong').should be_nil
    end

    it 'should not authenticate valid user with nil password' do
      User.authenticate('jordan', nil).should be_nil
    end

    it 'should not authenticate with invalid user name' do
      User.authenticate('invalid', 'anything').should be_nil
    end

    it 'should not authenticate with nil user name' do
      User.authenticate(nil, nil).should be_nil
    end
  end

  context 'validations' do
    it 'should have a name' do
      User.new.should have(1).error_on(:name)
    end

    it 'should have a name with valid characters' do
      User.new(name: 'INVALID').should have(1).error_on(:name)
    end

    it 'should have a password' do
      User.new.should have(1).error_on(:password)
    end

    it 'should have a unique name' do
      User.new(name: admin.name).should have(1).error_on(:name)
    end
  end
end
