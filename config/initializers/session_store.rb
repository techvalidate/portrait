# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_portrait_session',
  :secret      => '6df9592e7cb5d83401501822b2d20db1c0f3972a2b4356b03629b2a22b9d5a867587d69a01037387214280a1178e06fafc8ff2c880bde173d6338283e4152356'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
