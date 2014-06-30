class Admin
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_inactive_sign_up_path_for(_resource)
      admin_dashboard_path
    end
  end
end
