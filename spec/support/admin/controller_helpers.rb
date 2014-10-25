module ControllerHelpers
  def log_in_as_admin(admin)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(admin)
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end
