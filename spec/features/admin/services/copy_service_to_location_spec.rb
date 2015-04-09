require 'rails_helper'

describe 'Copy service to other locations' do
  context 'when organization has more than one location' do
    before do
      @location = create(:location)
      @new_loc = create(:far_loc, organization_id: @location.organization.id)
      @service = @location.services.create!(attributes_for(:service))
      login_super_admin
      visit '/admin/locations/vrs-services'
      click_link 'Literacy Program'
    end

    it 'shows the copy to location header' do
      expect(page).to have_content 'Copy this service to other Locations'
    end

    it 'does not provide the existing location as a choice' do
      expect(page).to_not have_unchecked_field 'VRS Services'
    end

    it 'unchecks all choices by default' do
      expect(page).to have_unchecked_field 'Belmont Farmers Market'
    end

    it 'allows copying the service to another location when authorized' do
      check 'Belmont Farmers Market'
      click_button 'Save changes'
      expect(page).to have_content 'successfully updated'
      expect(@new_loc.reload.services.pluck(:name)).to eq ['Literacy Program']
    end
  end

  context 'when organization only has one location' do
    before do
      @location = create(:location)
      @location.services.create!(attributes_for(:service))
      login_super_admin
      visit '/admin/locations/vrs-services'
      click_link 'Literacy Program'
    end

    it 'does not show the copy to location section' do
      expect(page).to_not have_content 'Copy this service to other Locations'
    end
  end

  context 'when service is present at more than one location' do
    before do
      @location = create(:location)
      @service = @location.services.create!(attributes_for(:service))
      @new_loc = create(:far_loc, organization_id: @location.organization.id)
      @new_loc.services.create!(attributes_for(:service))
      @third_loc = create(:nearby_loc, organization_id: @location.organization.id)
      @third_loc.services.create!(attributes_for(:service).
        merge(name: 'New Service'))

      login_super_admin
      visit '/admin/locations/belmont-farmers-market'
      click_link 'Literacy Program'
    end

    it 'does not show location that already has the service' do
      expect(page).to_not have_unchecked_field 'VRS Services'
    end

    it 'shows locations that do not have the service' do
      expect(page).to have_unchecked_field 'Library'
    end
  end
end
