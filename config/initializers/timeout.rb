Rack::Timeout.timeout = 10  # seconds

Rack::Timeout.unregister_state_change_observer(:logger) unless Rails.env.production?
