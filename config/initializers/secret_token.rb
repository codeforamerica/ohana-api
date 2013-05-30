# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
	raise 'The SECRET_TOKEN environment variable is not set.\n
	To generate it, run "rake secret", then set it with "heroku config:set SECRET_TOKEN=the_token_you_generated"'
end

OhanaApi::Application.config.secret_token = ENV['SECRET_TOKEN'] || '6bb1869cc43f25b000d02cf02245a55e330d67da37f97d2c6fb8cd12af3052bab3cc0f630938f531fa35b55976026458ac987e55c103600514bf4810a1945f96'
