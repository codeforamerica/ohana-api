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
      key_prefix: :throttle
    }
    @app, @options = app, options
  end

  # Check if the request needs throttling.
  # If so, it increases the rate limit counter and compares it with the maximum
  # allowed API calls. Returns true if a request can be handled.
  def allowed?(request)
    need_defense?(request) ? cache_counter(request, "incr") <= max_per_window(request) : true
  end

  def valid_user_agent?(request)
    user_agent = request.env["HTTP_USER_AGENT"]
    user_agent.present?
  end

  # If a conditional request was sent with the "If-None-Match" header,
  # and if the response was a 304/Not Modified, then we don't count it
  # against the rate limit, so we decrement the counter because it
  # was incremented before reaching this method (see the allowed? method).

  # For every request, we return the X-RateLimit-Limit and X-RateLimit-Remaining
  # HTTP headers so clients can check their status.

  # If the request does not include a User-Agent, we return a 403 with a
  # "Missing or invalid User Agent string" message.
  def call(env)
    request = Rack::Request.new(env)
    etag    = request.env["HTTP_IF_NONE_MATCH"]

    if (need_defense?(request) && !valid_user_agent?(request))
      http_error(request, "user agent")
    elsif allowed?(request)
      status, headers, response = app.call(env)

      cache_counter(request, "decr") if (etag.present? && status == 304 && need_defense?(request))

      headers = rate_limit_headers(request, headers) if request.fullpath.include?("api/")
      [status, headers, response]
    else
      http_error(request, "rate limit")
    end
  end

  def max_per_window(request)
    valid_api_token?(request) ? 5000 : 60
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

  def http_error(request, type)
    [403, {
             "Content-Type" => "application/json"
           }, [error_body(request, type).to_json]]
  end

  def error_body(request, type)
    body =
      {
        status: 403,
        method: request.env['REQUEST_METHOD'],
        request: "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}#{request.env['PATH_INFO']}",
      }
    if type == "rate limit"
      body[:description] = "Rate limit exceeded"
      body[:hourly_rate_limit] = max_per_window(request)
    elsif type == "user agent"
      body[:description] = "Missing or invalid User Agent string."
    end
    body
  end

  protected
  # only API calls should be throttled
  def need_defense?(request)
    request.fullpath.include?("api/") && !(request.fullpath.include?("api/rate_limit"))
  end

  # @param  [Rack::Request] request
  # @return [String]
  def client_identifier(request)
    if valid_api_token?(request)
      "#{request.ip.to_s}-#{api_token(request)}"
    else
     request.ip.to_s
    end
  end

  # @param  [Rack::Request] request
  # @return [Boolean]
  def valid_api_token?(request)
    token = api_token(request)
    token.present? && User.where('api_applications.api_token' => token).exists?
  end

  # @param  [Rack::Request] request
  # @return [String]
  def api_token(request)
    request.env["HTTP_X_API_TOKEN"].to_s
  end
end