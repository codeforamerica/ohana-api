require 'rails_helper'

feature 'Update how_to_apply' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with valid how_to_apply' do
    click_link 'Literacy Program'
    fill_in 'service_how_to_apply', with: 'Youth Counseling'
    click_button 'Save changes'
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_how_to_apply').value).to eq 'Youth Counseling'
  end
end
