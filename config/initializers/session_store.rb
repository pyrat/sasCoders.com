# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sasCoders_session',
  :secret      => '28ba5fdfa664756efc36d69e8a3516ebe0ab5923d3098b2d9b2715e18aec26c0fec2d345adde7f17bb7fde111c27bcb51ab2ec20ece368199be975f3c4056859'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
