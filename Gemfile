source 'https://rubygems.org'

ruby '2.1.1'
gem 'rails', '~> 4.1.1'

gem 'pg'

gem 'sass-rails',   '~> 4.0.3'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass', '~> 3.2.0'

# Rails 4
gem 'protected_attributes'
# gem 'rails-observers'
# gem 'rails-perftest'

# Front end
gem 'jquery-rails'
gem 'haml-rails', '~> 0.5.3'

# Server for deployment
gem 'unicorn'

# Geocoding
gem 'geocoder'
gem 'redis'

# CORS support
gem 'rack-cors', require: 'rack/cors'

# API Design
gem 'kaminari'
gem 'active_model_serializers', '~> 0.8.0'

# Production Monitoring
gem 'newrelic_rpm'
gem 'rack-timeout'

# Authentication
gem 'devise'

gem 'auto_strip_attributes', '~> 2.0'
gem 'enumerize'

# App config and ENV variables for heroku
gem 'figaro', '~> 1.0.0.rc1'

# Search
gem 'pg_search'

# Nested categories for OpenEligibility
gem 'ancestry'

gem 'friendly_id', '~> 5.0.3'

group :production, :staging do
  gem 'rails_12factor'
  gem 'sentry-raven'
end

group :test, :development do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails', '>= 4.2.0'
  gem 'bullet'
end

group :test do
  gem 'database_cleaner', '>= 1.0.0.RC1'
  gem 'capybara'
  gem 'poltergeist'
  gem 'shoulda-matchers', require: false
  gem 'coveralls', require: false
  gem 'rubocop'
  gem 'haml-lint'
end

group :development do
  gem 'quiet_assets', '>= 1.0.2'
  gem 'better_errors', '>= 0.7.2'
  gem 'binding_of_caller', '>= 0.7.1', platforms: [:mri_19, :rbx]
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'listen', '~> 1.0'
end
