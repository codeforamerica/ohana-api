Geocoder.configure(
  timeout: 30,
  lookup: :google,
  api_key: ENV['GOOGLE_GEOCODER_API_KEY'],
  use_https: true,
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
