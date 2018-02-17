module DefaultHeaders
  def post(uri, params = {}, session = {})
    super(
      uri,
      params: params.to_json,
      headers: {
        'HTTP_USER_AGENT' => 'Rspec',
        'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN'],
        'Content-Type' => 'application/json'
      }.merge!(session)
    )
  end

  def put(uri, params = {}, session = {})
    super(
      uri,
      params: params.to_json,
      headers: {
        'HTTP_USER_AGENT' => 'Rspec',
        'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN'],
        'Content-Type' => 'application/json'
      }.merge(session)
    )
  end

  def patch(uri, params = {}, session = {})
    super(
      uri,
      params: params.to_json,
      headers: {
        'HTTP_USER_AGENT' => 'Rspec',
        'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN'],
        'Content-Type' => 'application/json'
      }.merge(session)
    )
  end

  def get(uri, params = {}, session = {})
    super uri, params: params, headers: { 'HTTP_USER_AGENT' => 'Rspec' }.merge(session)
  end

  def delete(uri, params = {}, session = {})
    super(
      uri,
      params: params.to_json,
      headers: {
        'HTTP_USER_AGENT' => 'Rspec',
        'HTTP_X_API_TOKEN' => ENV['ADMIN_APP_TOKEN']
      }.merge(session)
    )
  end
end
