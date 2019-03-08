require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "sets session and redirects when successful" do
      user = users(:active_user)
      customer = user.customer
      post :create, params: { customer_name: customer.name, user_name: user.name, user_password: common_fixture_password }
      expect(response).to redirect_to(root_url)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe "GET #destroy" do
    it "clears session and redirects" do
      get :destroy
      expect(response).to redirect_to(root_url)
      expect(session[:user_id]).to be_nil
    end
  end

end
