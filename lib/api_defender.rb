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
      key_prefix: "ohanapi_defender",
      max: 60
    }
    @app, @options = app, options
  end

  # Check if the request needs throttling. 
  # If so, it increases the usage counter and compares it with maximum 
  # allowed API calls. Returns true if a request can be handled.
  def allowed?(request)
    need_defense?(request) ? cache_incr(request) <= max_per_window : true
  end

  def call(env)
    request = Rack::Request.new(env)
    if allowed?(request)
      status, headers, body = app.call(env)
      headers['X-RateLimit-Limit']     = max_per_window.to_s
      headers['X-RateLimit-Remaining'] = ([0, max_per_window - (cache_get(cache_key(request)).to_i rescue 1)].max).to_s
      [status, headers, body]
    else
      rate_limit_exceeded(request)
    end
  end

  # rack-throttle supports various key/value stores for storing rate-limiting counters.
  # This app uses Redis, so we'll use its 'key increase' and 'key expiration' features.
  def cache_incr(request)
    key = cache_key(request)
    count = cache.incr(key)
    cache.expire(key, 1.hour) if count == 1
    count
  end

  def rate_limit_exceeded(request)
    headers = respond_to?(:retry_after) ? {'Retry-After' => retry_after.to_f.ceil.to_s} : {}
    http_error(request, options[:code] || 403, options[:message] || 'Rate Limit Exceeded', headers)
  end

  def http_error(request, code, message = nil, headers = {})
    [code, { 'Content-Type' => 'application/json' }.merge(headers), [body(request).to_json]]
  end

  def body(request)
    {
      status: 403,
      method: request.env['REQUEST_METHOD'],
      request: "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}#{request.env['PATH_INFO']}",
      description: 'Rate limit exceeded',
      hourly_rate_limit: max_per_window
    }
  end

  protected
  # only API calls should be throttled
  def need_defense?(request)
    request.fullpath.include? "api/"
  end
end