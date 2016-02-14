require 'rails_helper'

feature "User Signin" do
  let(:user) { users(:joe) }

  describe "with valid information" do
    before do
      visit '/login'

      fill_in 'Email', with: "joe@example.com"
      fill_in 'Password', with: "secret007"

      click_button 'Log in'
    end

    it "should login user" do
      expect(page).to have_text('Log out')
    end

    it "should redirect user to the homepage" do
      expect(current_path).to eq(root_path)
    end
  end

  describe "with invalid information" do
    before do
      visit '/login'

      fill_in 'Email', with: "joe@example.com"
      fill_in 'Password', with: "forgot"

      click_button 'Log in'
    end

    it "should not login user" do
      expect(page).to have_text('Invalid email or password')
    end

    it "should leave user on the login page" do
      expect(current_path).to eq(user_session_path)
    end
  end

end