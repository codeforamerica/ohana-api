require 'rails_helper'

describe 'Update description' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  it 'with empty description' do
    fill_in 'service_description', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Description can't be blank for Service"
  end

  it 'with valid description' do
    fill_in 'service_description', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_description').value).to eq 'Youth Counseling'
  end
end
