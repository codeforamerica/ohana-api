require 'rails_helper'

feature 'Update contact name' do
  background do
    create_service
    @service.contacts.create!(attributes_for(:contact))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    click_link 'Moncef Belyamani'
  end

  scenario 'with empty name' do
    fill_in 'contact_name', with: ''
    click_button 'Save changes'
    expect(page).to have_content "Name can't be blank for Contact"
  end

  scenario 'with valid name' do
    fill_in 'contact_name', with: 'Monfresh'
    click_button 'Save changes'
    expect(page).to have_content 'Contact was successfully updated.'
    expect(find_field('contact_name').value).to eq 'Monfresh'
  end
end
