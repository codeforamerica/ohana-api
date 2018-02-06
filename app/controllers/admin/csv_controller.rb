class Admin
  class CsvController < ApplicationController
    before_action :authorize_admin
    # The CSV content for each action is defined in
    # app/views/admin/csv/{action_name}.csv.shaper

    def addresses; end

    def contacts; end

    def holiday_schedules; end

    def locations; end

    def mail_addresses; end

    def organizations; end

    def phones; end

    def programs; end

    def regular_schedules; end

    def services; end

    private

    def authorize_admin
      unless admin_signed_in?
        flash[:error] = t('devise.failure.unauthenticated')
        return redirect_to new_admin_session_url
      end
      user_not_authorized unless current_admin.super_admin?
    end
  end
end
