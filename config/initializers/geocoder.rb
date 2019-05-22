Geocoder.configure(
  timeout: 30,
  lookup: :geocoder_ca,
  use_https: true,
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
