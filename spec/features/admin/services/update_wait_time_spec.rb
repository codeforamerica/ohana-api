require 'rails_helper'

feature 'Update wait' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with valid wait' do
    click_link 'Literacy Program'
    fill_in 'service_wait', with: 'Youth Counseling'
    click_button 'Save changes'
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_wait').value).to eq 'Youth Counseling'
  end
end
