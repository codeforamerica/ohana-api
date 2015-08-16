require 'rails_helper'

feature 'Update name' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with empty name' do
    fill_in 'service_name', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Name can't be blank for Service"
  end

  scenario 'with valid name' do
    fill_in 'service_name', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_name').value).to eq 'Youth Counseling'
  end
end
