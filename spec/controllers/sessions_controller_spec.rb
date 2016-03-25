require 'rails_helper'

RSpec.describe SessionsController, type: :controller do


end

# it 'handles /forgot_password with GET' do
#   get :forgot_password
#   expect(response).to be_success
# end
#
# it 'handles /reset_password with valid params and POST' do
#   post :reset_password, name: 'jordan', email: 'test@test.com'
#   expect(response).to redirect_to('/forgot_password')
# end
#
# it 'sends an email when valid params posted to /reset_password' do
#   expect {
#     post :reset_password, name: 'jordan', email: 'test@test.com'
#   }.to change { ActionMailer::Base.deliveries.count }.by(1)
#
# end