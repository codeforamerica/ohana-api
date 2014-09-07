require 'rails_helper'

feature 'Update name' do
  background do
    create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with empty location name' do
    fill_in 'location_name', with: ''
    click_button 'Save changes'
    expect(page).to have_content "Name can't be blank for Location"
    expect(page).to have_css('.field_with_errors')
  end

  scenario 'with valid location name' do
    fill_in 'location_name', with: 'Juvenile Sexual Responsibility Program'
    click_button 'Save changes'
    expect(find_field('location_name').value).
      to eq 'Juvenile Sexual Responsibility Program'
  end
end
