require 'readthis'

cache = Readthis::Cache.new(
  redis: {
    url: ENV.fetch('REDISCLOUD_URL', 'redis://localhost:6379'),
    driver: :hiredis
  },
  expires_in: 2.weeks.to_i
)

Geocoder.configure(
  lookup: :google,
  cache: cache,
  http_proxy: ENV['QUOTAGUARD_URL'],
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
