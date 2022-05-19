Geocoder.configure(
  lookup: :google,
  api_key: ENV.fetch('GOOGLE_GEOCODING_API_KEY', nil),
  http_proxy: ENV.fetch('QUOTAGUARD_URL', nil),
  use_https: true,
  cache: Rails.cache,
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
