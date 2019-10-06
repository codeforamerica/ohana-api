source 'https://rubygems.org'

ruby '2.5.5'
gem 'active_model_serializers', '~> 0.8.0'
gem 'ancestry'
gem 'auto_strip_attributes', '~> 2.0'
gem 'bootstrap-sass', '~> 3.4.0'
gem 'coffee-rails', '~> 4.1'
gem 'csv_shaper'
gem 'dalli'
gem 'devise', '~> 4.1'
gem 'enumerize'
gem 'figaro', '~> 1.0'
gem 'friendly_id', '~> 5.0'
gem 'geocoder'
gem 'haml-rails'
gem 'jquery-rails', '~> 4.0'
gem 'kaminari', '~> 1.1'
gem 'kgio'
gem 'memcachier'
gem 'pg'
gem 'puma'
gem 'pundit'
gem 'rack-cache'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.1.5'
gem 'sassc-rails', '~> 2.1'
gem 'select2-rails', '~> 3.5'
gem 'uglifier', '>= 1.3.0'

group :test, :development do
  gem 'bullet'
  # rubocop:disable Metrics/LineLength
  gem 'factory_bot_rails'
  # rubocop:enable Metrics/LineLength
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.1'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'smarter_csv'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner', '>= 1.0.0.RC1'
  gem 'haml_lint'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git'
  gem 'simplecov', require: false
  gem 'webdrivers'
  gem 'webmock'
end

group :development do
  gem 'better_errors', '>= 0.7.2'
  gem 'binding_of_caller', platforms: %i[mri_19 rbx]
  gem 'bummr'
  gem 'derailed'
  gem 'flamegraph'
  gem 'letter_opener'
  gem 'rack-mini-profiler'
  gem 'reek'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
  gem 'stackprof'
end
