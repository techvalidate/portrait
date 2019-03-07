require 'rails_helper'

describe UsersController do
  before{ login_as :active_user }

  it 'handles /users with GET' do
    gt :users
    expect(response).to be_successful
    expect(assigns(:users).all? {|u| u.customer == @user.customer}).to be true
  end

  it 'handles /users/:id with GET' do
    gt users(:admin)
    expect(response).to be_successful
  end

  it 'handles different customer /users/:id with GET' do
    gt users(:different_admin)
    expect(response).to redirect_to(users_path)
  end

  it 'handles /users with valid params and POST' do
    login_as :active_admin
    expect {
      pst :users, user: { name: 'name', password: 'password' }
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(1)
    expect(assigns(:user).customer).to eq(@user.customer)
  end

  it 'handles /users with unauthorized POST' do
    login_as :active_user
    expect {
      pst :users, user: { name: 'name', password: 'password' }
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(0)
    expect(flash[:error]).to be_present
  end

  it 'handles /users with invalid params and POST' do
    login_as :active_admin
    expect {
      pst :users, user: { name: 'name', password: '' }
    }.to change(User, :count).by(0)
    expect(response).to be_successful
    expect(assigns(:users).all? {|u| u.customer == @user.customer}).to be true
  end

  it 'handles /users/:id with valid params and PUT' do
    login_as :active_admin
    user = users(:admin)
    ptch user, user: { name: 'new' }
    expect(user.reload.name).to eq('new')
    expect(response).to redirect_to(user_path(user))
  end

  it 'handles /users/:id with unauthorized PUT' do
    login_as :active_user
    user = users(:admin)
    expected_name = user.name

    ptch user, user: { name: 'new' }
    
    expect(user.reload.name).to eq(expected_name)
    expect(response).to redirect_to(users_path)
    expect(flash[:error]).to be_present
  end

  it 'handles different customer /users/:id with PUT' do
    user = users(:different_admin)
    expected_name = user.name

    ptch user, user: { name: 'new' }

    expect(user.reload.name).to eq(expected_name)
    expect(response).to redirect_to(users_path)
  end

  it 'handles /users/:id with invalid params and PUT' do
    login_as :active_admin
    user = users(:admin)
    ptch user, user: { password: '' }
    expect(user.reload.name).not_to be_blank
    expect(response).to be_successful
    expect(response).to render_template(:show)
  end

  it 'handles /users/:id with DELETE' do
    login_as :active_admin
    expect {
      del users(:admin)
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(-1)
  end

  it 'handles /users/:id with unauthorized DELETE' do
    login_as :active_user
    expect {
      del users(:admin)
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(0)
    expect(flash[:error]).to be_present
  end

  it 'handles different customer /users/:id with DELETE' do
    login_as :active_admin
    expect {
      del users(:different_admin)
      expect(response).to redirect_to(users_path)
    }.to change(User, :count).by(0)
  end

end
