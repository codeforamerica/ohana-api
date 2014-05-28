require 'raven'

Raven.configure do |config|
  if Rails.env.production? && ENV['SENTRY_DSN'].blank?
    fail 'The SENTRY_DSN environment variable is not set on the production ' \
      'server! If you\'re using Heroku, you can find it by clicking on the ' \
      'Sentry add-on, then viewing the API Keys section in the Settings tab.' \
      ' Copy the long key that starts with https and paste it when you set ' \
      'the environment variable: heroku config:set SENTRY_DSN=the_token.'
  end
  config.dsn = ENV['SENTRY_DSN'] || '123abcd'
end
