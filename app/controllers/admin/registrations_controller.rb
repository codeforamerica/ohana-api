class Admin
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    include PrivateRegistration

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

    def after_inactive_sign_up_url_for(_resource)
      new_admin_session_url
    end

    def after_update_path_for(_resource)
      edit_admin_registration_url
    end
  end
end
