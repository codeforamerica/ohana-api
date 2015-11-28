require 'rails_helper'

feature 'Update short description' do
  background do
    create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with empty description' do
    fill_in 'location_short_desc', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('location_short_desc').value).to eq ''
  end

  scenario 'with valid description' do
    fill_in 'location_short_desc', with: 'This is a short description'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('location_short_desc').value).
      to eq 'This is a short description'
  end
end
