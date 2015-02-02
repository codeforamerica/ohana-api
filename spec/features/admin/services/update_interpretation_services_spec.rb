require 'rails_helper'

feature 'Update interpretation_services' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with valid interpretation_services' do
    click_link 'Literacy Program'
    fill_in 'service_interpretation_services', with: 'CTS LanguageLink'
    click_button 'Save changes'
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_interpretation_services').value).to eq 'CTS LanguageLink'
  end
end
