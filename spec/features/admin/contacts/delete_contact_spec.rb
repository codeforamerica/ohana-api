require 'rails_helper'

feature 'Delete contact' do
  background do
    @location = create(:location)
    @location.contacts.create!(attributes_for(:contact))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Moncef Belyamani'
  end

  scenario 'when deleting contact' do
    find_link(I18n.t('admin.buttons.delete_contact')).click
    using_wait_time 5 do
      expect(current_path).to eq admin_location_path(@location)
      expect(page).not_to have_link 'Moncef Belyamani'
    end
  end
end
