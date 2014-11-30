require 'rails_helper'

feature 'Update website' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with invalid website' do
    fill_in 'service_website', with: 'www.monfresh.com'
    click_button 'Save changes'
    expect(page).to have_content 'www.monfresh.com is not a valid URL'
    expect(page).to have_css('.field_with_errors')
  end

  scenario 'with valid website' do
    fill_in 'service_website', with: 'http://codeforamerica.org'
    click_button 'Save changes'
    expect(find_field('service_website').value).
      to eq 'http://codeforamerica.org'
  end
end
