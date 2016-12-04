source 'https://rubygems.org'

ruby '2.3.3'

gem 'active_model_serializers', '~> 0.8.0'
gem 'ancestry'
gem 'auto_strip_attributes', '~> 2.0'
gem 'bootstrap-sass', '~> 3.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'csv_shaper'
gem 'devise', '~> 4.1'
gem 'enumerize'
gem 'figaro', '~> 1.0'
gem 'friendly_id', '~> 5.0'
gem 'geocoder'
gem 'haml-rails'
gem 'honeybadger', '~> 2.0'
gem 'jquery-rails', '~> 4.0'
gem 'kaminari'
gem 'pg'
gem 'protected_attributes'
gem 'pundit'
gem 'rabl'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 4.2'
gem 'redis'
gem 'redis-rack-cache', github: 'monfresh/redis-rack-cache', branch: 'readthis-compatibility'
gem 'rubyzip'
gem 'sass-rails', '~> 5.0'
gem 'select2-rails', '~> 3.5'
gem 'sucker_punch'
gem 'uglifier', '>= 1.3.0'

group :production do
  gem 'puma'
  gem 'rails_12factor'
end

group :test, :development do
  gem 'bullet'
  gem 'factory_girl_rails', '>= 4.2.0'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.1'
  gem 'smarter_csv'
end

group :test do
  gem 'capybara'
  gem 'coveralls', require: false
  gem 'database_cleaner', '>= 1.0.0.RC1'
  gem 'haml_lint'
  gem 'poltergeist'
  gem 'rubocop'
  gem 'shoulda-matchers', require: false
  gem 'test_after_commit'
  gem 'webmock'
end

group :development do
  gem 'better_errors', '>= 0.7.2'
  gem 'binding_of_caller', '>= 0.7.1', platforms: [:mri_19, :rbx]
  gem 'bummr'
  # For profiling the app's performance and memory usage.
  gem 'derailed'
  gem 'flamegraph'
  gem 'letter_opener'
  gem 'quiet_assets', '>= 1.0.2'
  gem 'rack-mini-profiler'
  gem 'reek'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
  gem 'stackprof'
end
