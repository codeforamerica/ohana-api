Geocoder.configure(
  lookup: :google,
  http_proxy: ENV['QUOTAGUARD_URL'],
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
