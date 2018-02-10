require 'rails_helper'

describe Admin::CsvController do
  describe 'GET [table]' do
    it 'denies access if not a super admin' do
      log_in_as_admin(:admin)

      actions = %i[
        addresses contacts holiday_schedules locations mail_addresses
        organizations phones programs regular_schedules services
      ]
      actions.each do |action|
        get action, format: :csv

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    it 'denies access if not signed in' do
      actions = %i[
        addresses contacts holiday_schedules locations mail_addresses
        organizations phones programs regular_schedules services
      ]
      actions.each do |action|
        get action, format: :csv

        expect(response).to redirect_to new_admin_session_url
        expect(flash[:error]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    it 'allows access if signed in as a super admin' do
      log_in_as_admin(:super_admin)

      actions = %i[
        addresses contacts holiday_schedules locations mail_addresses
        organizations phones programs regular_schedules services
      ]
      actions.each do |action|
        get action, format: :csv

        expect(response.status).to eq 200
      end
    end
  end
end
