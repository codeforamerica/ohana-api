class Admin
  class DashboardController < ApplicationController
    layout 'admin'

    def index
      @admin = current_admin
    end
  end
end
