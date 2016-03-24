require 'rails_helper'
require 'byebug'
describe UsersController do
  before{ login_as :jordan }

  it 'handles /users with GET' do
    get :index
    expect(response).to be_success
  end

  it 'handles /users/:id with GET' do
    get :show, id: users(:jordan)
    expect(response).to be_success
  end

  it 'handles /users with valid params and POST' do
    expect {
      post :create, user: { name: 'name', password: 'password', email: 'name@test.com' }
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(1)
  end

  it 'handles /users/:id with valid params and PUT' do
    user = users(:jordan)
    put :update, id: user.to_param, user: { name: 'new', email: 'new@test.com'}

    expect(user.reload.name).to eq('new')
    expect(response).to redirect_to(user_path(user))
  end

  it 'handles /users/:id with invalid params and PUT' do
    user = users(:jordan)
    put :update, id: user, user: { email: '' }
    expect(user.reload.name).not_to be_blank
    expect(response).to be_success
    expect(response).to render_template(:show)
  end

  it 'handles /users/:id with DELETE' do
    expect {
      delete :destroy, id: users(:jordan)
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(-1)
  end

  it 'handles /forgot_password with GET' do
    get :forgot_password
    expect(response).to be_success
  end

  it 'handles /reset_password with valid params and POST' do
    post :reset_password, name: 'jordan', email: 'test@test.com'
    expect(response).to redirect_to('/forgot_password')
  end

  it 'sends an email when valid params posted to /reset_password' do
    expect {
      post :reset_password, name: 'jordan', email: 'test@test.com'
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

  end
end
