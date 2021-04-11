require 'rails_helper'

describe 'Update interpretation_services' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  it 'with valid interpretation_services' do
    click_link 'Literacy Program'
    fill_in 'service_interpretation_services', with: 'CTS LanguageLink'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_interpretation_services').value).to eq 'CTS LanguageLink'
  end
end
