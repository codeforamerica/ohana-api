class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  skip_before_action :verify_authenticity_token

  respond_to :json

  def create
    build_resource(sign_up_params)
    if resource.save
      build_organization
      UserMailer.new_registration(resource).deliver_now
    end
    render_resource(resource)
  end

  private

  def build_organization
    return unless sign_up_params[:organization_name].present? ||
                  sign_up_params[:organization_description].present?
    Organization.create!(
      name: sign_up_params[:organization_name],
      description: sign_up_params[:organization_description],
      user_id: resource.id
    )
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:name, :organization_name, :organization_description]
    )
  end

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end
end
