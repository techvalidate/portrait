require 'rails_helper'

describe Admin::UsersController do
  before{ login_as :admin }

  it 'handles /users with GET' do
    get :index
    expect(response).to be_success
  end

  it 'handles /users/:id with GET' do
    get :show, id: users(:joe)
    expect(response).to be_success
  end

  it 'handles /users/:id with valid params and PUT' do
    user = users(:joe)
    put :update, id: user.to_param, user: { name: 'new' }
    expect(user.reload.name).to eq('new')
    expect(response).to redirect_to(admin_user_path(user))
  end

  it 'handles /users/:id with invalid params and PUT' do
    user = users(:joe)
    put :update, id: user, user: { email: '' }
    expect(user.reload.email).not_to be_blank
    expect(response).to be_success
    expect(response).to render_template(:show)
  end

  it 'handles /users/:id with DELETE' do
    expect {
      delete :destroy, id: users(:joe)
      expect(response).to redirect_to(admin_users_path)
    }.to change(User, :count).by(-1)
  end

end
