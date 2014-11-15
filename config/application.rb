require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

SETTINGS = YAML.load(File.read(File.expand_path('../settings.yml', __FILE__)))
SETTINGS.merge! SETTINGS.fetch(Rails.env, {})
SETTINGS.symbolize_keys!

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OhanaApi
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')

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

    config.active_record.schema_format = :sql

    # CORS support
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource %r{/locations|organizations|search/*},
                 headers: :any,
                 methods: [:get, :put, :patch, :post, :delete],
                 expose: ['Etag', 'Last-Modified', 'Link', 'X-Total-Count']
      end
    end

    # This is required to be able to pass in an empty array as a JSON parameter
    # when updating a Postgres array field. Otherwise, Rails will convert the
    # empty array to `nil`. Search for "deep munge" on the rails/rails GitHub
    # repo for more details.
    config.action_dispatch.perform_deep_munge = false
  end
end
