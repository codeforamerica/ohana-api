require 'rails_helper'

feature 'Update virtual attribute' do
  background do
    create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'setting to true' do
    select('Does not have a physical address', from: 'location_virtual')
    click_button 'Save changes'
    expect(find_field('location_virtual').value).to eq 'true'
  end
end
