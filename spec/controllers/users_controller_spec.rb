require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  before(:each) { login_as :jordan }
  
  it 'handles /users with GET' do
    get :index
    response.should be_success
  end
  
  it 'handles /users/:id with GET' do
    get :show, id: users(:jordan)
    response.should be_success
  end
  
  it 'handles /users with valid params and POST' do
    running {
      post :create, user: {name: 'name', password: 'password', email: 'name@example.com'}
      response.should redirect_to(users_path)
    }.should change(User, :count).by(1)
  end
  
  it 'handles /users/:id with valid params and PUT' do
    user = users(:jordan)
    put :update, id: user.to_param, user: {name: 'new', password: 'password'}
    user.reload.name.should == 'new'
    response.should redirect_to(user_path(user))
  end
  
  it 'handles /users/:id with invalid params and PUT' do
    user = users(:jordan)
    put :update, id: user, user: {password: ''}
    user.reload.name.should_not == ''
    response.should be_success
    response.should render_template(:show)
  end
  
  it 'handles /users/:id with DELETE' do
    running {
      delete :destroy, id: users(:jordan)
      response.should redirect_to(users_path)
    }.should change(User, :count).by(-1)
  end

end
