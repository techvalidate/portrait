require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  
  test 'load index page' do
    get :index
    assert_response :success
    assert_not_nil :sites
  end
  
  test 'submiting a valid url' do
    assert_difference 'Site.count' do
      post :create, :site=>{:url=>'http://google.com'}
      assert_redirected_to sites_path
    end
  end
  
  test 'submiting an empty url' do
    assert_no_difference 'Site.count' do
      post :create
      assert_response :success
      assert_template :index
    end
  end
  
  test 'submitting an invalid url' do
    assert_no_difference 'Site.count' do
      post :create, :site=>{:url=>'fake'}
      assert_response :success
      assert_template :index
    end
  end
  
end
