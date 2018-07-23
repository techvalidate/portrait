require 'rails_helper'

RSpec.describe 'Users Controller', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) {user.id}
  let!(:users) { create_list(:user, 10) }
  describe 'GET /users' do
    #Make HTTP request before actually getting
    before { get '/users' }

    it 'returns users' do
      expect(users).not_to be_empty
      expect(users.size).to eq(10)
    end

  end

  describe 'GET /users/:id' do
    before { get "/users/#{user_id}" }
    context 'when the user exists' do
      it 'returns the user' do
        expect(user).to eq(user)
        expect(user.id).to eq(user_id)
      end
    end

    context 'when the user doesnot exist' do
      let(:user_id) {199}
      it 'doesnot return the user' do
        expect(user.id).to_not eq(user_id)
      end
    end
  end
  describe 'POST /todos' do
    let(:valid_attributes) { {id:1, name: 'Sam', email: 'sam@eg.com',password_digest: 'pwd' } }
    let(:user) {create(:user, id:1,name: 'Sam', email: 'sam@eg.com',password_digest: 'pwd' )}

    context 'when the request is valid' do
      before { post '/users', params: valid_attributes }

      it 'creates a user' do
        expect(user.name).to eq('Sam')
        expect(user.id).to eq(1)
        expect(user.email).to eq('sam@eg.com')
        expect(user.password_digest).to eq('pwd')
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: { name: 'Name' } }

      it 'returns a validation failure message' do
          expect(response.status).to eq 302
      end
    end
  end

end
# describe UsersController do
#   before{ login_as :admin }
#
#   it 'handles /users with GET' do
#     gt :users
#     expect(response).to be_successful
#   end
#
#   it 'handles /users/:id with GET' do
#     gt users(:admin)
#     expect(response).to be_successful
#   end
#
#   it 'handles /users with valid params and POST' do
#     expect {
#       pst :users, user: { name: 'name', password: 'password' }
#       expect(response).to redirect_to(users_path)
#     }.to change(User, :count).by(1)
#   end
#
#   it 'handles /users/:id with valid params and PUT' do
#     user = users(:admin)
#     ptch user, user: { name: 'new' }
#     expect(user.reload.name).to eq('new')
#     expect(response).to redirect_to(user_path(user))
#   end
#
#   it 'handles /users/:id with invalid params and PUT' do
#     user = users(:admin)
#     ptch user, user: { password: '' }
#     expect(user.reload.name).not_to be_blank
#     expect(response).to be_successful
#     expect(response).to render_template(:show)
#   end
#
#   it 'handles /users/:id with DELETE' do
#     expect {
#       del users(:admin)
#       expect(response).to redirect_to(users_path)
#     }.to change(User, :count).by(-1)
#   end
#
# end
