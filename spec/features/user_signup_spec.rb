require 'rails_helper'

feature "User Signup" do
  describe "with valid information" do
    before do
      visit '/'
      click_link 'Sign up'

      fill_in 'Name', with: 'james'
      fill_in 'Email', with: "example@techvalidate.com"
      fill_in 'Password', with: "secret007"
      fill_in 'Password confirmation', with: "secret007"
    end

    it "should create a user" do
      expect { click_button 'Sign up' }.to change(User, :count).by(1)
    end

    it "should redirect user to the homepage" do
      click_button 'Sign up'
      expect(current_path).to eq(root_path)
    end
  end

  describe "with invalid information" do
    before do
      visit '/'
      click_link 'Sign up'

      within '#new_user' do
        fill_in 'Email', with: "example"
      end
    end

    it "should create a user" do
      expect { click_button 'Sign up' }.not_to change { User.count }
    end

    it "should redirect user back to the sign up page" do
      click_button 'Sign up'
      expect(current_path).to eq(user_registration_path)
    end

    it "should display validation errors to the user" do
      click_button 'Sign up'
      expect(page).to have_text("Name can't be blank")
      expect(page).to have_text("Email is invalid")
      expect(page).to have_text("Password can't be blank")
    end
  end
end