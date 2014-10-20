require 'rails_helper'

feature 'Update email' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with invalid email' do
    fill_in 'service_email', with: 'foobar.com'
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid email'
  end

  scenario 'with valid email' do
    fill_in 'service_email', with: 'ruby@good.com'
    click_button 'Save changes'
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_email').value).to eq 'ruby@good.com'
  end
end
