module TokenValidator
  def validate_token!
    render_401 unless valid_api_token?
  end

  def valid_api_token?
    token = env['HTTP_X_API_TOKEN'].to_s
    token.present? && token == ENV['ADMIN_APP_TOKEN']
  end

  def render_401
    hash =
      {
        'message' => 'This action requires a valid X-API-Token header.',
        'status' => 401
      }
    render json: hash, status: 401
  end
end
