require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  before(:each) { login_as admin }

  it 'handles /users with GET' do
    get :index
    response.should be_success
  end

  it 'handles /users/:id with GET' do
    get :show, id: admin
    response.should be_success
  end

  it 'handles /users with valid params and POST' do
    running {
      post :create, user: {name: 'name', password: 'password'}
      response.should redirect_to(users_path)
    }.should change(User, :count).by(1)
  end

  it 'handles /users/:id with valid params and PUT' do
    put :update, id: admin.to_param, user: {name: 'new'}
    admin.reload.name.should == 'new'
    response.should redirect_to(user_path(admin))
  end

  it 'handles /users/:id with invalid params and PUT' do
    put :update, id: admin, user: {password: ''}
    admin.reload.name.should_not == ''
    response.should be_success
    response.should render_template(:show)
  end

  it 'handles /users/:id with DELETE' do
    running {
      delete :destroy, id: admin
      response.should redirect_to(users_path)
    }.should change(User, :count).by(-1)
  end

end
