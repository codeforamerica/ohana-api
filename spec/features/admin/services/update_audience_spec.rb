require 'rails_helper'

feature 'Update audience' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with valid audience' do
    click_link 'Literacy Program'
    fill_in 'service_audience', with: 'Youth Counseling'
    click_button 'Save changes'
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_audience').value).to eq 'Youth Counseling'
  end
end
