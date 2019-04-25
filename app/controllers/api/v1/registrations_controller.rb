class Api::V1::RegistrationsController < Devise::RegistrationsController
  include ActiveSupport::Rescuable
  include ErrorSerializer

  before_action :configure_permitted_parameters
  before_action :authenticate_api_user!, only: [:update, :destroy, :show]
  skip_before_action :verify_authenticity_token

  respond_to :json

  def create
    ActiveRecord::Base.transaction do
      build_resource(sign_up_params)
      resource.save!
      resource.build_organization(
        name: params[:api_user][:organization_name],
        description: params[:api_user][:organization_description],
        email: params[:api_user][:email],
        approval_status: 'pending'
      )
      resource.organization.save!
      UserMailer.new_registration(resource).deliver_now
      SuperAdminMailer.new_registration(resource).deliver_now
      render_resource(resource)
    end
  # rescue ActiveRecord::RecordInvalid => error
  #   render status: 422,
  #          json: { model: error.record.class.to_s, errors: error.record.errors }
  # rescue ActiveRecord::RecordNotUnique => error
  #   render status: 422,
  #          json: { model: 'Organization', errors: { name: ['has already been taken'] } }
  end

  def show
    if current_api_user.present?
      render json: current_api_user, serializer: UserSerializer
    else
      render json: []
    end
  end

  def update
    if account_update_params[:password].present?
      current_api_user.update_with_password(account_update_params)
    else
      current_api_user.update(sign_up_params)
    end
    if current_api_user.errors.empty?
      render json: current_api_user, serializer: UserSerializer
    else
      render json: ErrorSerializer.serialize(current_api_user.errors),
             status: :unprocessable_entity
    end
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    resource.destroy
    render json: { message: 'User was deleted successfully' },
           status: :ok
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:name]
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
