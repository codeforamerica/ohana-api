module DefaultUserAgent

  def post(uri, params = {}, session = {})
    super uri, params, {'HTTP_USER_AGENT' => "Rspec"}.merge(session)
  end

  def get(uri, params = {}, session = {})
    super uri, params, {'HTTP_USER_AGENT' => "Rspec"}.merge(session)
  end

  def put(uri, params = {}, session = {})
    super uri, params, {'HTTP_USER_AGENT' => "Rspec"}.merge(session)
  end

end