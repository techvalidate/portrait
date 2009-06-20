require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  
  test 'validates an url' do
    assert !Site.new.valid?
  end
  
  test 'validate url format' do
    assert !Site.new(:url=>'invalid').valid?
  end
  
end
