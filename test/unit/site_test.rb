require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  
  test 'validates an url' do
    site = Site.new
    assert !site.valid?
  end
  
  test 'validate url format' do
    site = Site.new :url=>'invalid'
    assert !site.valid?
  end
  
end
