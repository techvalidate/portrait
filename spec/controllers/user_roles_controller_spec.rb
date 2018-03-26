require 'rails_helper'

RSpec.describe UsersRolesController, type: :controller do

  describe "POST #create" do
    let(:user) { User.create(name: "user", email: "email@email.com", password: "password") }
    let(:role) { Role.create(name: "testrole") }
    let(:valid_params) { { user_id: user.id, role_id: role.id } }

    before do
      admin = User.create name: 'admin2', password: 'admin2', email: 'admin@email.com'
      admin_role = Role.create name: 'Site Admin'
      admin_group = Group.create name: 'Site Admin'

      admin.groups << admin_group
      admin.roles << admin_role

      request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin2:admin2")

      post :create, params: valid_params
    end

    it "redirects to role show page" do
      expect(response).to redirect_to(role_path(role))
    end

    it "sets flash message" do
      expect(flash[:notice]).to eq('User successfully added!')
    end

    it "adds the user to the role" do
      expect(user.roles.first).to eq(role)
    end
  end

  describe "DELETE #delete" do
    let(:user) { User.create(name: "user", email: "email@email.com", password: "password") }
    let(:role) { Role.create(name: "testrole") }
    let(:valid_params) { { user_id: user.id, role_id: role.id, id: role.id } }

    before do
      admin = User.create name: 'admin2', password: 'admin2', email: 'admin@email.com'
      admin_role = Role.create name: 'Site Admin'
      admin_group = Group.create name: 'Site Admin'

      admin.groups << admin_group
      admin.roles << admin_role

      request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin2:admin2")

      user.roles << role

      delete :destroy, params: valid_params
    end

    it "redirects to role show page" do
      expect(response).to redirect_to(role_path(role))
    end

    it "sets flash message" do
      expect(flash[:notice]).to eq('User successfully removed.')
    end

    it "removes the user from the role" do
      expect(user.roles.active).to be_empty
    end
  end
end
