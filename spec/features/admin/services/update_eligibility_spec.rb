require 'rails_helper'

describe 'Update eligibility' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  it 'with valid eligibility' do
    click_link 'Literacy Program'
    fill_in 'service_eligibility', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_eligibility').value).to eq 'Youth Counseling'
  end
end
