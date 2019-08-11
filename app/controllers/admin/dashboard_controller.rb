class Admin
  class DashboardController < ApplicationController
    layout 'admin'

    def index
      redirect_to new_admin_session_url unless admin_signed_in?
      @orgs = policy_scope(Organization) if current_admin
      @version = OHANA_API_VERSION
    end
  end
end
