require 'rails_helper'

feature 'Update status' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with valid status' do
    click_link 'Literacy Program'
    select 'Defunct', from: 'service_status'
    click_button 'Save changes'
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_status').value).to eq 'defunct'
  end
end
