# Set this to at least 5 seconds less than the Unicorn timeout in
# config/unicorn.rb. The rack-timeout gem allows you to troubleshoot
# H13 errors on Heroku by providing a stack trace.
Rack::Timeout.timeout = 10