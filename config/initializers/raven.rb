require 'raven'

Raven.configure do |config|
  if Rails.env.production?
    config.dsn = ENV["SENTRY_DSN"] or raise "missing SENTRY_DSN environment variable"
  end
end