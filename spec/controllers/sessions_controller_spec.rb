require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  it 'should handle /sessions/new with GET' do
    get :new

    expect(response).to be_successful
  end

  it 'should handle /sessions/create with valid params and POST' do
    user = users(:jordan)
    session[:forwarding_url] = nil
    post :create, session: { name: 'jordan', password: 'password' }

    expect(session[:user_id]).to eq(user.id)
    expect(response).to redirect_to user
  end
  it 'should handle /session/create with invalid params and POST' do
    post :create, session: { name: 'not_a_user', password: 'not_a_password'}

    expect(response).to redirect_to login_path
  end
  it 'should handle /session/create with a redirect to cached forwarding url' do
    user = users(:jordan)
    session[:forwarding_url] = users_path
    post :create, session: {name: 'jordan', password: 'password'}

    expect(response).to redirect_to users_path
  end

  it 'should handle /sessions/destroy with DELETE' do
    delete :destroy

    expect(session[:user_id]).to eq(nil)
  end

end

