require 'rails_helper'

describe 'ability to add an admin to a location' do
  before(:each) do
    @location = create(:location)
  end

  context 'when neither super admin nor location admin' do
    it "doesn't allow adding an admin" do
      login_admin
      visit '/admin/locations/vrs-services'
      expect(page).to_not have_content 'Add an admin email'
    end
  end

  context 'when super admin' do
    it 'allows adding an admin' do
      login_super_admin
      visit '/admin/locations/vrs-services'
      expect(page).to have_content 'Add an admin email'
    end
  end

  context 'when admin belongs to org' do
    it 'allows adding an admin' do
      create(:location_for_org_admin)
      login_admin
      visit '/admin/locations/samaritan-house'
      expect(page).to have_content 'Add an admin email'
    end
  end

  context 'when location admin' do
    it 'allows adding an admin' do
      new_admin = create(:admin_with_generic_email)
      @location.update!(admin_emails: ['moncef@gmail.com'])
      login_as_admin(new_admin)
      visit '/admin/locations/vrs-services'
      expect(page).to have_content 'Add an admin email'
    end
  end
end
