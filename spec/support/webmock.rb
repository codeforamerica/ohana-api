require 'webmock/rspec'

WebMock.disable_net_connect!(
  allow: [
    /localhost/,
    /127\.0\.0\.1/,
    /codeclimate.com/, # For uploading coverage reports
    /chromedriver\.storage\.googleapis\.com/ # For fetching a chromedriver binary
  ]
)
