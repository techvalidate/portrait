require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  before {
    @user = users(:jordan)
    @mail =  UserMailer.reset_password(@user)
  }
  describe :reset_password do

    it 'should render a subject' do
      expect(@mail.subject).to eq('Instructions to reset your password')
    end

    it 'should send to users email' do
      expect(@mail.to).to eq([@user.email])
    end

    it 'should render default from email' do
      expect(@mail.from).to eq([UserMailer.default_params[:from]])
    end

    it 'should display users name' do
      expect(@mail.body.encoded).to match(@user.name)
    end

    it 'should render password reset url' do
      expect(@mail.body.encoded).to match(edit_password_reset_url(@user.password_reset_token))
    end
  end
end
