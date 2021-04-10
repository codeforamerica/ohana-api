require 'rails_helper'

describe 'Delete contact' do
  before do
    @location = create(:location)
    @location.contacts.create!(attributes_for(:contact))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Moncef Belyamani'
  end

  it 'when deleting contact' do
    find_link(I18n.t('admin.buttons.delete_contact')).click
    using_wait_time 5 do
      expect(page).to have_current_path admin_location_path(@location), ignore_query: true
      expect(page).not_to have_link 'Moncef Belyamani'
    end
  end
end
