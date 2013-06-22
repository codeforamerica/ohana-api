require 'rack/throttle'
# This custom class extends the Hourly Throttling strategy provided
# by the 'rack-throttle' gem: https://github.com/datagraph/rack-throttle
# Inspired by redis-throttle (https://github.com/andreareginato/redis-throttle)
# and this blog post:
# http://martinciu.com/2011/08/how-to-add-api-throttle-to-your-rails-app.html
class ApiDefender < Rack::Throttle::Hourly

  def initialize(app)
    options = {
      # The REDIS constant is defined in config/initializers/geocoder.rb
      cache: REDIS,
      key_prefix: "ohanapi_defender"
    }
    @app, @options = app, options
  end

  # Check if the request needs throttling.
  # If so, it increases the rate limit counter and compares it with the maximum
  # allowed API calls. Returns true if a request can be handled.
  def allowed?(request)
    need_defense?(request) ? cache_counter(request, "incr") <= max_per_window(request) : true
  end

  # If a conditional request was sent with the "If-None-Match" header,
  # and if the response was a 304/Not Modified, then we don't count it
  # against the rate limit, so we decrement the counter because it
  # was incremented before reaching this method (see the allowed? method).
  # For every request, we return the X-RateLimit-Limit and X-RateLimit-Remaining
  # HTTP headers so clients can check their status.
  def call(env)
    request = Rack::Request.new(env)
    etag    = request.env["HTTP_IF_NONE_MATCH"]
    if allowed?(request)
      status, headers, response = app.call(env)
      cache_counter(request, "decr") if (etag.present? && status == 304)
      headers = rate_limit_headers(request, headers)
      [status, headers, response]
    else
      rate_limit_exceeded(request)
    end
  end

  def max_per_window(request)
    token = request.env["HTTP_X_API_TOKEN"].to_s
    (token.present? && User.where('api_applications.api_token' => token).exists?) ? 5000 : 60
  end

  # rack-throttle supports various key/value stores for storing rate-limiting
  # counters.This app uses Redis, so we'll use its 'key increase' and
  # 'key expiration' features.
  def cache_counter(request, action)
    key = cache_key(request)
    action == "incr" ? count = cache.incr(key) : count = cache.decr(key)
    cache.expire(key, 1.hour) if count == 1
    count
  end

  def rate_limit_headers(request, headers)
    headers["X-RateLimit-Limit"]     = max_per_window(request).to_s
    headers["X-RateLimit-Remaining"] = ([0, max_per_window(request) - (cache_get(cache_key(request)).to_i rescue 1)].max).to_s
    headers
  end

  def rate_limit_exceeded(request)
    headers = respond_to?(:retry_after) ? {"Retry-After" => retry_after.to_f.ceil.to_s} : {}
    http_error(request, options[:code] || 403, headers)
  end

  def http_error(request, code, headers = {})
    [code, {
             "Content-Type" => "application/json"
           }.merge(headers), [body(request).to_json]]
  end

  def body(request)
    {
      status: 403,
      method: request.env['REQUEST_METHOD'],
      request: "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}#{request.env['PATH_INFO']}",
      description: "Rate limit exceeded",
      hourly_rate_limit: max_per_window(request)
    }
  end

  protected
  # only API calls should be throttled
  def need_defense?(request)
    request.fullpath.include?("api/")
  end
end