require 'rails_helper'

describe 'Delete location' do
  before do
    create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  it 'when submitting warning', :js do
    find_link(I18n.t('admin.buttons.delete_location')).click
    find_link(I18n.t('admin.buttons.confirm_delete_location')).click
    using_wait_time 5 do
      expect(page).to have_current_path admin_locations_path, ignore_query: true
      expect(page).not_to have_link 'VRS Services'
    end
  end

  it 'when canceling warning', :js do
    find_link(I18n.t('admin.buttons.delete_location')).click
    find_button('Close').click
    visit admin_locations_path
    expect(page).to have_link 'VRS Services'
  end
end
