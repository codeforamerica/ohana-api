source 'https://rubygems.org'

ruby '2.2.1'
gem 'rails', '~> 4.1.1'

gem 'pg'

gem 'sass-rails',   '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass', '~> 3.3.0'

# Rails 4
gem 'protected_attributes'
# gem 'rails-observers'
# gem 'rails-perftest'

# Front end
gem 'jquery-rails', '~> 3.0'
gem 'haml-rails'
gem 'select2-rails'

# Server for deployment
gem 'puma'

# Geocoding
gem 'geocoder'

# CORS support
gem 'rack-cors', require: 'rack/cors'

# API Design
gem 'kaminari'
gem 'active_model_serializers', '~> 0.8.0'

# Authentication
gem 'devise', '~> 3.4'

# Authorization
gem 'pundit'

gem 'auto_strip_attributes', '~> 2.0'
gem 'enumerize'

# App config and ENV variables for heroku
gem 'figaro', '~> 1.0'

# Search
gem 'pg_search'

# Nested categories for OpenEligibility
gem 'ancestry'

gem 'friendly_id', '~> 5.0'

gem 'rack-timeout'

# Caching
gem 'rack-cache'
gem 'dalli'
gem 'kgio'
gem 'memcachier'

group :production do
  # Heroku recommended
  gem 'rails_12factor'
end

group :test, :development do
  gem 'rspec-rails', '~> 3.1'
  gem 'rspec-its'
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
  gem 'spring-watcher-listen'
end
