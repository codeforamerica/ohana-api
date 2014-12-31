# Set the TIMEOUT config var to at least 5 seconds less than the Unicorn
# timeout in config/unicorn.rb. The rack-timeout gem allows you to troubleshoot
# H13 errors on Heroku by providing a stack trace.
Rack::Timeout.timeout = ENV['TIMEOUT'].to_i

Rack::Timeout.unregister_state_change_observer(:logger) unless Rails.env.production?
