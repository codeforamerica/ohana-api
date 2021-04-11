require 'rails_helper'

describe 'Update alternate_name' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  it 'with valid alternate_name' do
    fill_in 'service_alternate_name', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_alternate_name').value).to eq 'Youth Counseling'
  end
end
