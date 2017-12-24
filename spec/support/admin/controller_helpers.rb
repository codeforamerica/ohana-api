module ControllerHelpers
  def log_in_as_admin(admin)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    sign_in FactoryBot.create(admin)
  end
end
