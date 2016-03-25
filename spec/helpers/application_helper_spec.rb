require 'rails_helper'


RSpec.describe ApplicationHelper, type: :helper do
  it 'should create a session user_id when a user logs in' do
    user = users(:jordan)
    log_in user

    expect(session[:user_id]).to eq(user.id)
  end

  it 'should delete the session user_id when a user logs out' do
    user = users(:jordan)
    log_in user

    expect {
      log_out
    }.to change{session[:user_id]}.to eq(nil)
  end

  it 'should return the current user' do
    user = users(:jordan)
    log_in user

    expect(current_user).to eq(user)
  end

  it 'should return if a user is logged_in' do
    user = users(:jordan)
    log_in user

    expect(logged_in?).to be_truthy
  end

end
