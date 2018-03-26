require 'rails_helper'

RSpec.describe UsersGroupsController, type: :controller do

  describe "POST #create" do
    let(:user) { User.create(name: "user", email: "email@email.com", password: "password") }
    let(:group) { Group.create(name: "testgroup") }
    let(:valid_params) { { user_id: user.id, group_id: group.id } }

    before do
      admin = User.create name: 'admin2', password: 'admin2', email: 'admin@email.com'
      admin_role = Role.create name: 'Site Admin'
      admin_group = Group.create name: 'Site Admin'

      admin.groups << admin_group
      admin.roles << admin_role

      request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin2:admin2")

      post :create, params: valid_params
    end

    it "redirects to group show page" do
      expect(response).to redirect_to(group_path(group))
    end

    it "sets flash message" do
      expect(flash[:notice]).to eq('User successfully added!')
    end

    it "adds the user to the group" do
      expect(user.groups.first).to eq(group)
    end
  end

  describe "DELETE #delete" do
    let(:user) { User.create(name: "user", email: "email@email.com", password: "password") }
    let(:group) { Group.create(name: "testgroup") }
    let(:valid_params) { { user_id: user.id, group_id: group.id, id: group.id } }

    before do
      admin = User.create name: 'admin2', password: 'admin2', email: 'admin@email.com'
      admin_role = Role.create name: 'Site Admin'
      admin_group = Group.create name: 'Site Admin'

      admin.groups << admin_group
      admin.roles << admin_role

      request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin2:admin2")

      user.groups << group

      delete :destroy, params: valid_params
    end

    it "redirects to group show page" do
      expect(response).to redirect_to(group_path(group))
    end

    it "sets flash message" do
      expect(flash[:notice]).to eq('User successfully removed.')
    end

    it "removes the user from the group" do
      expect(user.groups.active).to be_empty
    end
  end
end
