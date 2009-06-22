require 'yaml'
db = YAML.load_file 'config/database.yml'
ActionController::Base.session = {
  :key    => db[RAILS_ENV]['session_key'],
  :secret => db[RAILS_ENV]['secret']
}


