require Rails.root.join('lib/config_validator.rb')

# Define the environment variables that should be set in config/application.yml.
# See config/application.example.yml if you don't have config/application.yml.
Figaro.require_keys('API_PATH') if ENV['API_SUBDOMAIN'].blank?
Figaro.require_keys('ADMIN_PATH') if ENV['ADMIN_SUBDOMAIN'].blank?
Figaro.require_keys(
  'ASSET_HOST',
  'DEFAULT_PER_PAGE',
  'DOMAIN_NAME',
  'MAX_PER_PAGE'
)
ConfigValidator.new.validate
