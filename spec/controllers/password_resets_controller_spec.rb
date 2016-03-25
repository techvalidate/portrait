require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do

  it 'handles /password_resets/new with GET' do
    get :new
    expect(response).to be_successful
  end

  it 'handles /password_resets/create with valid params and POST' do
    user = users(:jordan)
    expect {
      post :create, email: user.email
      expect(flash[:success]).to eq('Instructions to reset your password have been sent to ' + user.email)
    }.to change {
      ActionMailer::Base.deliveries.count
    }.by(1)


  end

  it 'handles /password_resets/create with invalid params and POST' do
    post :create, email: 'incorrect@email.com'

    expect(response).to redirect_to '/forgot_password'
    expect(flash[:notice]).to eq('User with no such email could be found')
  end

  it 'handles /password_resets/#{password_reset_token}/edit with valid params and GET' do
    user = users(:jordan)
    get :edit, id: user.password_reset_token

    expect(response).to be_successful
  end

  it 'handles /password_resets/#{password_reset_token/edit with invalid params and GET' do
    get :edit, id: 'randomIncorrectToken'

    expect(response).to redirect_to '/forgot_password'
    expect(flash[:notice]).to eq('No such user')
  end

  it 'handles /password_resets/update with valid params and PUT' do
    user = users(:jordan)
    user.password_reset_sent_at = Time.zone.now
    user.save
    put :update, id:user.password_reset_token, user: {name: user.name, password: 'newpassword', email: user.email}

    expect(response).to redirect_to login_url
    expect(flash[:success]).to eq('Password has been reset')
    expect(user.reload.authenticate('newpassword')).to eq(user)
  end


end
