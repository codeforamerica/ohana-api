require "redis"

if Rails.env.production?
  REDIS = Redis.connect(url: ENV["REDISTOGO_URL"])
else
  REDIS = Redis.new
end

Geocoder.configure(:lookup => :mapquest, :cache => REDIS, :always_raise => [Geocoder::OverQueryLimitError, Geocoder::RequestDenied, Geocoder::InvalidRequest, Geocoder::InvalidApiKey])