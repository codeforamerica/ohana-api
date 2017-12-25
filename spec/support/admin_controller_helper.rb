module AdminControllerHelper
  def log_in_as_admin(admin)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    sign_in FactoryBot.create(admin)
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include AdminControllerHelper, type: :controller
end
