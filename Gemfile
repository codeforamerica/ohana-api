source 'https://rubygems.org'

ruby '2.1.1'
gem 'rails', '~> 4.0.4'

gem "pg"

gem 'sass-rails',   '~> 4.0.2'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass'

# Rails 4
gem 'protected_attributes'
#gem 'rails-observers'
#gem 'rails-perftest'

# Front end
gem 'jquery-rails'
gem "haml-rails", '~> 0.5.3'

# Server for deployment
gem "passenger"

group :production, :staging do
  gem 'rails_12factor' # Heroku recommended
end

group :test, :development do
  gem "rspec-rails", '~> 2.14.2'
  gem "factory_girl_rails", ">= 4.2.0"
end

group :test do
  gem "database_cleaner", ">= 1.0.0.RC1"
  gem "capybara"
  #gem "minitest"
  gem 'shoulda-matchers'
  # Test coverage
  gem 'coveralls', require: false
end

group :development do
  # Debugging
  #gem "bullet"
  gem "quiet_assets", ">= 1.0.2"
  gem "better_errors", ">= 0.7.2"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]
  #gem "debugger"

  # Code quality and style
  gem "metric_fu"
end

# Geocoding
gem "geocoder", :git => "git://github.com/alexreisner/geocoder.git", :ref => "3568e5e8e6"
gem "redis"

# Format validation for URLs, phone numbers, zipcodes
gem "validates_formatting_of", '~> 0.8.1'

# CORS support
gem 'rack-cors', :require => 'rack/cors'

# API Design
gem "grape"
gem 'grape-entity'
gem "kaminari", :git => "git://github.com/amatsuda/kaminari.git", :ref => "01f65e112d"

# Caching
#gem "garner"
gem 'dalli'
gem 'kgio'
gem 'memcachier'

# API Documentation
gem "grape-swagger"
gem 'swagger-ui_rails'

# Production Monitoring
gem 'newrelic_rpm'
gem 'newrelic-grape'
gem "rack-timeout"

# Uncomment if you're using Rate Limiting
#gem 'rack-throttle'

# Authentication
gem 'devise'

gem "attribute_normalizer"
gem "enumerize"

# App config and ENV variables for heroku
gem "figaro"

# Search
gem "tire", :git => "git://github.com/monfresh/tire.git", :ref => "2d174e792a"

# Nested categories for OpenEligibility
gem "ancestry"

gem "friendly_id", "~> 5.0.3"