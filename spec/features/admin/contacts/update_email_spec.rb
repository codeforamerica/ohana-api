require 'rails_helper'

feature 'Update email' do
  background do
    location = create(:location)
    location.contacts.create!(attributes_for(:contact))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Moncef Belyamani'
  end

  scenario 'with invalid email' do
    fill_in 'contact_email', with: 'foobar'
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid email'
  end

  scenario 'with valid email' do
    fill_in 'contact_email', with: 'foo@bar.com'
    click_button 'Save changes'
    expect(page).to have_content 'Contact was successfully updated.'
    expect(find_field('contact_email').value).to eq 'foo@bar.com'
  end
end
