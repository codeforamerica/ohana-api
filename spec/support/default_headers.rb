module DefaultHeaders
  def post(uri, params = {}, session = {})
    super uri, params.to_json, {
      'HTTP_USER_AGENT' => 'Rspec',
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN'],
      'Content-Type' => 'application/json'
    }.merge(session)
  end

  def put(uri, params = {}, session = {})
    super uri, params.to_json, {
      'HTTP_USER_AGENT' => 'Rspec',
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN'],
      'Content-Type' => 'application/json'
    }.merge(session)
  end

  def patch(uri, params = {}, session = {})
    super uri, params.to_json, {
      'HTTP_USER_AGENT' => 'Rspec',
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN'],
      'Content-Type' => 'application/json'
    }.merge(session)
  end

  def get(uri, params = {}, session = {})
    super uri, params, { 'HTTP_USER_AGENT' => 'Rspec' }.merge(session)
  end

  def delete(uri, params = {}, session = {})
    super uri, params, {
      'HTTP_USER_AGENT' => 'Rspec',
      'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
    }.merge(session)
  end
end
