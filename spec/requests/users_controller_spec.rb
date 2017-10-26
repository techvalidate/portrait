require 'rails_helper'

describe UsersController do
  before{ login_as :jordan }

  it 'handles /users with GET' do
    gt :users
    expect(response).to be_success
  end

  it 'handles /users/:id with GET' do
    gt users(:jordan)
    expect(response).to be_success
  end

  it 'handles /users with valid params and POST' do
    expect {
      pst :users, user: { name: 'name', password: 'password' }
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(1)
  end

  it 'handles /users/:id with valid params and PUT' do
    user = users(:jordan)
    pt user, user: { name: 'new' }
    expect(user.reload.name).to eq('new')
    expect(response).to redirect_to(user_path(user))
  end

  it 'handles /users/:id with invalid params and PUT' do
    user = users(:jordan)
    pt user, user: { password: '' }
    expect(user.reload.name).not_to be_blank
    expect(response).to be_success
    expect(response).to render_template(:show)
  end

  it 'handles /users/:id with DELETE' do
    expect {
      del users(:jordan)
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(-1)
  end

end
