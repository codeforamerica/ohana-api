require 'redis'

REDIS = Redis.connect(url: ENV['REDISTOGO_URL'])

Geocoder.configure(
  lookup: :google,
  cache: REDIS,
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
