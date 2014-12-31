class Admin
  class DashboardController < ApplicationController
    layout 'admin'

    def index
      redirect_to new_session_path(:admin) unless admin_signed_in?
      @orgs = policy_scope(Organization) if current_admin
    end
  end
end
