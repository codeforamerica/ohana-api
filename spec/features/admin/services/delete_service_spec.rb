require 'rails_helper'

feature 'Delete service' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'when submitting warning', :js do
    click_link 'Literacy Program'
    find_link(I18n.t('admin.buttons.delete_service')).click
    find_link(I18n.t('admin.buttons.confirm_delete_service')).click
    using_wait_time 5 do
      expect(current_path).to eq admin_locations_path
    end
    click_link 'VRS Services'
    expect(page).not_to have_link 'Literacy Program'
  end

  scenario 'when canceling warning', :js do
    click_link 'Literacy Program'
    find_link(I18n.t('admin.buttons.delete_service')).click
    find_button('Close').click
    visit '/admin/locations/vrs-services'
    expect(page).to have_link 'Literacy Program'
  end
end
