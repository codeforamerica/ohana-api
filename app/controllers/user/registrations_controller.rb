class User
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up).push(:name)
      devise_parameter_sanitizer.for(:account_update).push(:name)
    end

    def after_update_path_for(_resource)
      edit_user_registration_path
    end
  end
end
