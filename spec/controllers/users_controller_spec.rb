require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }

  shared_examples "insufficient credentials" do
    it "fails on index" do
      get :index
      response.should_not be_success
    end

    it "fails on show" do
      get :show, id: user
      response.should_not be_success
    end

    it "fails on create" do
      post :create, user: {email: 'test@example.com', password: '12345678'}
      response.should_not be_success
    end

    it "fails on update" do
      put :update, id: user, user: {email: 'new@test.com'}
      response.should_not be_success
    end

    it "fails on destroy" do
      delete :destroy, id: user
      response.should_not be_success
    end

  end

  context "not logged in" do
    it_behaves_like "insufficient credentials"
  end

  context "logged in as a user" do
    before(:each) { sign_in user }

    it_behaves_like "insufficient credentials"
  end

  context "logged in as an administrator" do
    let(:admin)   { FactoryGirl.create(:user, :admin) }
    before(:each) { sign_in admin }

    it 'succeeds on index' do
      get :index
      response.should be_success
    end

    describe '.show' do
      context 'with valid parameters' do
        it 'succeeds on show' do
          get :show, id: admin
          response.should be_success
        end
      end
      context 'with invalid parameters' do
        it "redirects to index" do
          get :show, id: 100
          response.should render_template(:index)
        end
      end
    end

    describe '.create' do
      shared_examples 'post invalid paramaters' do
        it 'does not add a user' do
          expect {
            post_invalid_params
          }.to_not change(User, :count)
        end
        it 'renders user index' do
          post_invalid_params
          response.should render_template(:index)
        end
      end
      context 'with valid parameters' do
        let(:valid_post) { post :create, user: {email: 'test@example.com', password: '12345678'} }

        it 'increases User.count by 1' do
          expect {
            valid_post
          }.to change(User, :count).by(1)
        end
        it 'redirects to users path' do
          valid_post
          response.should redirect_to(users_path)
        end
      end
      context 'with invalid email' do
        let(:post_invalid_params) { post :create, user: {email: 'INVALID', password: '12345678'} }
        it_behaves_like 'post invalid paramaters'
      end
      context 'with invalid password' do
        let(:post_invalid_params) { post :create, user: {email: 'test@example.com', password: 'INVALID'} }
        it_behaves_like 'post invalid paramaters'
      end
    end

    describe '.update' do
      shared_examples 'update invalid params' do
        it 'renders show' do
          update_invalid_params
          response.should_not be_redirect
        end
        it 'does not update the user' do
          expect {
            update_invalid_params
          }.to_not change { admin.reload }
        end
      end
      context 'with valid parameters' do
        let(:valid_update) { put :update, id: admin, user: {email: 'test@example.com'} }
        it 'updates the email' do
          valid_update
          admin.reload.email.should == 'test@example.com'
        end
        it 'redirects to user path' do
          valid_update
          response.should redirect_to(user_path(admin))
        end
      end
      context 'with invalid email' do
        let(:update_invalid_params) { put :update, id: admin, user: {email: ''} }
        it_behaves_like 'update invalid params'
      end
      context 'with invalid id' do
        let(:update_invalid_params) { put :update, id: 100, user: {email: 'test@example.com'} }
        it_behaves_like 'update invalid params'
      end
    end

    it 'handles /users/:id with invalid params and PUT' do
      put :update, id: admin, user: {password: ''}
      admin.reload.name.should_not == ''
      response.should be_success
      response.should render_template(:show)
    end

    describe ".destroy" do
      let!(:user2) { FactoryGirl.create(:user) }

      context "with valid parameters" do
        let(:valid_delete) { delete :destroy, id: user2 }

        it "destroys a record" do
          expect { valid_delete }.to change(User, :count).by(-1)
        end
        it "redirects to user index" do
          valid_delete
          response.should redirect_to(users_path)
        end
      end
      context "with invalid parameters" do
        let(:invalid_delete) { delete :destroy, id: 100 }

        it "redirects to index" do
          invalid_delete
          response.should render_template(:index)
        end

        it "does not destroy a record" do
          expect { invalid_delete }.to_not change(User, :count)
        end
      end
    end

  end
end
