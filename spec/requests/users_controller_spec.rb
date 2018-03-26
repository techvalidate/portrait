require 'rails_helper'

describe UsersController do
  before do
    login_as :admin
    admin_role = Role.create name: 'Site Admin'
    User.find_by(name: 'admin').roles << admin_role
  end

  it 'handles /users with GET' do
    gt :users
    expect(response).to be_successful
  end

  it 'handles /users/:id with GET' do
    gt users(:admin)
    expect(response).to be_successful
  end

  it 'handles /users with valid params and POST' do
    expect {
      pst :users, user: { name: 'name', email: 'admin@email.com', password: 'password' }
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(1)
  end

  it 'handles /users/:id with valid params and PUT' do
    user = users(:admin)
    ptch user, user: { name: 'new', email: 'admin@email.com', password: 'password' }
    expect(user.reload.name).to eq('new')
    expect(response).to redirect_to(user_path(user))
  end

  it 'handles /users/:id with invalid params and PUT' do
    user = users(:admin)
    ptch user, user: { password: '' }
    expect(user.reload.name).not_to be_blank
    expect(response).to be_successful
    expect(response).to render_template(:show)
  end

  it 'handles /users/:id with DELETE' do
    expect {
      del users(:admin)
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(-1)
  end

end
