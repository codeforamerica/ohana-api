require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OhanaApi
  class Application < Rails::Application
    # don't generate RSpec tests for views and helpers
    config.generators do |g|

      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'

      g.view_specs false
      g.helper_specs false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run 'rake -D time' for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    ## Uncomment the following 2 lines if you want to activate rate limiting
    ## You would also need to uncomment the following specs:
    ## no_api_token_spec.rb, api_token_spec.rb, no_user_agent_spec.rb,
    ## rate_limit_spec.rb, and re-enable any pending specs related to
    ## rate limiting.
    # require 'api_defender'
    # config.middleware.insert_after Rack::Lock, ApiDefender

    # CORS support
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        # location of your API
        resource '/api/*', headers: :any, methods: [:get, :post, :options, :put]
      end
    end
  end
end
