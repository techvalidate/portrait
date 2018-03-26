require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    let(:email) { "email@email.com" }
    let(:valid_params) { { email: email } }

    before do
      u = User.create(name: "user", email: email, password: "email")

      post :create, params: valid_params
    end

    it "redirects to root" do
      expect(response).to redirect_to(root_path)
    end

    it "sets flash message" do
      expect(flash[:notice]).to eq('E-mail sent with password reset instructions.')
    end
  end

  describe "GET #edit" do
    let(:email) { "email@email.com" }
    before do
      @user = User.create(name: "user", email: email, password: "email")
      @user.send_password_reset

      get :edit, params: { id: @user.password_reset_token }
    end

    it "returns success" do
      expect(response.status).to eq(200)
    end

    it "assigns user" do
      expect(assigns(:user)).to eq(@user)
    end
  end

  describe "PUT #update" do
    let(:valid_params) { { password: "password", password_confirmation: "password" } }

    let(:email) { "email@email.com" }

    context "success" do
      before do
        @user = User.create(name: "user", email: email, password: "email")
        @user.send_password_reset

        put :update, params: { id: @user.password_reset_token, user: valid_params }
      end

      it "returns success" do
        expect(response).to redirect_to(root_path)
      end

      it "assigns user" do
        expect(assigns(:user)).to eq(@user)
      end
    end

    context "reset expired" do
      before do
        @user = User.create(name: "user", email: email, password: "email")
        @user.send_password_reset

        @user.password_reset_sent_at = Time.now - 3.hours
        @user.save

        put :update, params: { id: @user.password_reset_token, user: valid_params }
      end

      it "sets flash message" do
        expect(flash[:notice]).to eq("Password reset has expired")
      end

      it "assigns user" do
        expect(assigns(:user)).to eq(@user)
      end

      it "redirects to new password reset" do
        expect(response).to redirect_to(new_password_reset_path)
      end
    end

    context "reset expired" do
      let(:params) { { password: 'password', password_confirmation: 'non-match' } }
      before do
        @user = User.create(name: "user", email: email, password: "email")
        @user.send_password_reset

        put :update, params: { id: @user.password_reset_token, user: params }
      end

      it "sets flash message" do
        expect(flash[:notice]).to eq("Password confirmation mismatch")
      end

      it "assigns user" do
        expect(assigns(:user)).to eq(@user)
      end

      it "renders edit" do
        expect(response).to render_template("edit")
      end
    end

  end

end
