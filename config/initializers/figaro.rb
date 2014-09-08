# Define the environment variables that should be set in config/application.yml.
# See config/application.example.yml if you don't have config/application.yml.
Figaro.require('API_PATH') unless ENV['API_SUBDOMAIN'].present?
Figaro.require('ADMIN_PATH') unless ENV['ADMIN_SUBDOMAIN'].present?
Figaro.require('DEFAULT_PER_PAGE')
Figaro.require('MAX_PER_PAGE')
