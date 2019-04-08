require 'devise/jwt/test_helpers'

module ControllerHelpers
  def log_in_as_admin(admin)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(admin)
  end

  def api_login(user)
    headers = {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
    # This will add a valid token for `user` in the `Authorization` header
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end
