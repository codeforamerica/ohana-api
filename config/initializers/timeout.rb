Rack::Timeout.timeout = ENV['TIMEOUT'].to_i

Rack::Timeout.unregister_state_change_observer(:logger) unless Rails.env.production?
