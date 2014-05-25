# If the API is configured to require a User-Agent header, this module
# can be included in specs so that all requests automatically have the
# User-Agent header appended to them.
# Usage: add "include DefaultUserAgent" in the "describe" block of the spec.
module DefaultUserAgent
  def post(uri, params = {}, session = {})
    super uri, params, { 'HTTP_USER_AGENT' => 'Rspec' }.merge(session)
  end

  def get(uri, params = {}, session = {})
    super uri, params, { 'HTTP_USER_AGENT' => 'Rspec' }.merge(session)
  end

  def put(uri, params = {}, session = {})
    super uri, params, { 'HTTP_USER_AGENT' => 'Rspec' }.merge(session)
  end
end
