require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  
  test 'load index page' do
    get :index
    assert_response :success
    assert_not_nil :sites
  end
  
end
