require 'rails_helper'

feature "User signs out" do
  before do
    visit '/login'
    fill_in 'Name', with: 'joe'
    fill_in 'Password', with: 'secret007'
    click_button 'Log in'
  end

  it "by clicking on 'Log out'" do
    click_link 'Log out'

    expect(page).to have_text('Log in')
  end
end