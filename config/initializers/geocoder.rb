require "redis"

if Rails.env.production?
  REDIS = Redis.connect(url: ENV["REDISTOGO_URL"])
elsif Rails.env.test?
	REDIS = Redis.new(db: 1)
else
  REDIS = Redis.new
end

Geocoder.configure(
  :lookup => :google,
  :cache => REDIS,
  :bounds => [[37.1074,-122.521], [37.7084,-122.085]],
  :always_raise => [Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey])