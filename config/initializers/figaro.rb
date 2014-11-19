# Define the environment variables that should be set in config/application.yml.
# See config/application.example.yml if you don't have config/application.yml.
Figaro.require_keys('API_PATH') unless ENV['API_SUBDOMAIN'].present?
Figaro.require_keys('ADMIN_PATH') unless ENV['ADMIN_SUBDOMAIN'].present?
Figaro.require_keys('DEFAULT_PER_PAGE', 'MAX_PER_PAGE')
