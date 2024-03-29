Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # This setting enables the use of subdomains on Heroku.
  # See config/settings.yml for more details.
  config.action_dispatch.tld_length = ENV['TLD_LENGTH'].to_i

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.version` and `config.assets.precompile` have moved to
  # config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = (ENV['ENABLE_HTTPS'] == 'yes')

  # Use the info log level to ensure that sensitive information
  # in SQL statements is not saved.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # --------------------------------------------------------------------------
  # CACHING SETUP FOR RACK:CACHE AND MEMCACHIER ON HEROKU
  # https://devcenter.heroku.com/articles/rack-cache-memcached-rails31
  # ------------------------------------------------------------------

  config.public_file_server.enabled = true

  config.action_controller.perform_caching = true
  # Specify the asset_host to prevent host header injection.
  require 'asset_hosts'
  config.action_controller.asset_host = AssetHosts.new

  config.cache_store = :dalli_store
  client = Dalli::Client.new((ENV.fetch('MEMCACHIER_SERVERS', '')).split(','),
                             username: ENV.fetch('MEMCACHIER_USERNAME', nil),
                             password: ENV.fetch('MEMCACHIER_PASSWORD', nil),
                             failover: true,
                             socket_timeout: 1.5,
                             socket_failure_delay: 0.2,
                             value_max_bytes: 10_485_760)

  # Enable Rack::Cache to put a simple HTTP cache in front of your application.
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  config.action_dispatch.rack_cache = {
    metastore: client,
    entitystore: client,
    verbose: false
  }
  config.public_file_server.headers = { 'Cache-Control' => 'public, max-age=2592000' }
  # --------------------------------------------------------------------------

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: ENV.fetch('MAILER_URL', nil) }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.perform_caching = false

  config.action_mailer.default charset: 'utf-8'

  config.action_mailer.smtp_settings = {
    port: '587',
    address: 'smtp.sendgrid.net',
    user_name: ENV.fetch('SENDGRID_USERNAME', nil),
    password: ENV.fetch('SENDGRID_PASSWORD', nil),
    domain: 'heroku.com',
    authentication: :plain,
    enable_starttls_auto: true
  }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)
end
