class PasswordsController < Devise::PasswordsController
  include ErrorSerializer

  skip_before_action :verify_authenticity_token

  def create
    self.resource = resource_class
      .send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render json: resource, serializer: UserSerializer
    else
      render json: ErrorSerializer.serialize(resource.errors),
             status: :unprocessable_entity
    end
  end
end
