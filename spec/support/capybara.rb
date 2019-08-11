require 'webdrivers/chromedriver'
require 'selenium/webdriver'

Capybara.configure do |config|
  config.default_max_wait_time = 5
  config.always_include_port = true
end

Capybara.register_driver :headless_chrome do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 options: browser_options
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_driver = :rack_test

Webdrivers.cache_time = 86_400
