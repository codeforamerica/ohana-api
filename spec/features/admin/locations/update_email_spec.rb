require 'rails_helper'

feature 'Update email' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with valid location email' do
    fill_in 'location_email', with: 'foo@bar.com'
    click_button 'Save changes'
    expect(find_field('location_email').value).to eq 'foo@bar.com'
  end

  scenario 'with invalid location email' do
    fill_in 'location_email', with: 'foobar.com'
    click_button 'Save changes'
    expect(page).to have_content 'foobar.com is not a valid email'
  end
end
