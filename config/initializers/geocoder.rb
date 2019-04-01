Geocoder.configure(
  lookup: :google,
  api_key: ENV['GOOGLE_GEOCODING_API_KEY'],
  http_proxy: ENV['QUOTAGUARD_URL'],
  use_https: true,
  cache: Rails.cache,
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
