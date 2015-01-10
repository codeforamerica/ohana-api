ENV['RAILS_ENV'] ||= 'test'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!('rails')

  SimpleCov.start do
    add_filter '.bundle'
    add_filter 'spec'
  end
end

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/its'
require 'shoulda/matchers'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 30

Rails.logger.level = 4

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Features::SessionHelpers, type: :feature
  config.include Features::FormHelpers, type: :feature
  config.include Features::ScheduleHelpers, type: :feature
  config.include Features::PhoneHelpers, type: :feature
  config.include Features::ContactHelpers, type: :feature
  config.include Requests::RequestHelpers, type: :request
  config.include DefaultHeaders, type: :request
  config.include MailerMacros

  # rspec-rails 3+ will no longer automatically infer an example group's spec
  # type from the file location. You can explicitly opt-in to this feature by
  # uncommenting the setting below.
  config.infer_spec_type_from_file_location!

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/support/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  # require 'active_record_spec_helper'
end
