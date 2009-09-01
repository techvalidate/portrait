# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml'
  config.gem 'paperclip'
  config.gem 'mislav-will_paginate', :source=>'http://gems.github.com', :lib=>'will_paginate'
  
  config.gem 'rspec',       :lib => false, :version=>'>= 1.2.0'
  config.gem 'rspec-rails', :lib => false, :version=>'>= 1.2.0' 
  
  config.time_zone = 'UTC'
end