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

  # Add user agent and subdomain information to the log
  # config.log_tags = [:subdomain, ->(request) { request.user_agent }]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # --------------------------------------------------------------------------
  # CACHING SETUP FOR REDISCLOUD ON HEROKU
  # --------------------------------------------------------------------------

  config.serve_static_files = true

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = ENV['FASTLY_CDN_URL']

  config.static_cache_control = 'public, s-maxage=2592000, maxage=86400'

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  config.action_controller.perform_caching = true

  # config.cache_store = :readthis_store, {
  #   redis: { url: ENV.fetch('REDISCLOUD_URL'), driver: :hiredis },
  #   expires_in: 2.weeks.to_i,
  #   namespace: 'cache'
  # }

  # config.action_dispatch.rack_cache = {
  #   metastore: "#{ENV.fetch('REDISCLOUD_URL')}/0/metastore",
  #   entitystore: "#{ENV.fetch('REDISCLOUD_URL')}/0/entitystore",
  #   use_native_ttl: true,
  #   verbose: false
  # }
  # --------------------------------------------------------------------------

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: ENV['MAILER_URL'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true

  config.action_mailer.default charset: 'utf-8'

  config.action_mailer.smtp_settings = {
    port:           '587',
    address:        'smtp.sendgrid.net',
    user_name:      ENV['SENDGRID_USERNAME'],
    password:       ENV['SENDGRID_PASSWORD'],
    domain:         'heroku.com',
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
end
