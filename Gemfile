source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '3.2.13'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

# Front end
gem 'jquery-rails'
gem "jquery-ui-rails"
gem "haml-rails", ">= 0.4"

# Server for deployment
gem "unicorn", ">= 4.3.1"

# Test coverage
gem 'coveralls', require: false

# MongoDB ORM
gem "mongoid", ">= 3.1.2"

group :test, :development do
  # Testing with Rspec
  gem "rspec-rails", ">= 2.12.2"
  gem "factory_girl_rails", ">= 4.2.0"
end

group :test do
  # Testing with Rspec and Mongoid
  gem "database_cleaner", ">= 1.0.0.RC1"
  gem "mongoid-rspec", ">= 1.7.0"
  gem "capybara"
end

group :development do
  # Debugging
  gem "bullet"
  gem "quiet_assets", ">= 1.0.2"
  gem "better_errors", ">= 0.7.2"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]

  # Code quality and style
  gem "metric_fu"

end

# Geocoding
gem "geocoder", :git => "git://github.com/alexreisner/geocoder.git", :ref => "bb2d338afc"
gem "redis"

# Format validation for URLs, phone numbers, zipcodes
gem "area"
gem "validates_formatting_of"

# CORS support
gem 'rack-cors', :require => 'rack/cors'

# API Design
gem 'rocket_pants', '~> 1.0'
gem "kaminari"
gem 'api-pagination'

# Production Monitoring
gem 'newrelic_rpm'
gem "rack-timeout"

# Rate Limiting
gem 'rack-throttle'

# Authentication & Administration
gem 'devise'
gem 'activeadmin-mongoid', :git => "git://github.com/monfresh/activeadmin-mongoid.git", :branch => "filter-fix"
#gem 'activeadmin-mongoid', :git => "git://github.com/elia/activeadmin-mongoid.git"
gem "cancan"
gem "attribute_normalizer"

# App config and ENV variables for heroku
gem "figaro"

# Search
gem 'mongoid_search', :git => "git://github.com/mauriciozaffari/mongoid_search.git"