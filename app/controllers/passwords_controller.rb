class PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token

  def create
    self.resource = resource_class
      .send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render json: resource, serializer: UserSerializer
    else
      render(
        json: resource,
        status: :unprocessable_entity,
        serializer: ActiveModel::Serializer::ErrorSerializer
      )
    end
  end
end
