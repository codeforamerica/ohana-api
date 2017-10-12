Geocoder.configure(
  timeout: 30,
  lookup: :google,
  api_key: "AIzaSyBBQCLJbfB0LTgOURyVuwPyuEik9EGoGEw",
  use_https: true,
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]

)
