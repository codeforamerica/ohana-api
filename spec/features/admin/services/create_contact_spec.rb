require 'rails_helper'

feature 'Create a new contact for service' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    click_link 'Add a new contact'
  end

  it 'creates a contact for the right service' do
    expect(page).to have_content "Creating contact for #{@service.name}"
  end

  scenario 'with all required fields' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    click_button 'Create contact'
    click_link 'New VRS Services contact'

    expect(find_field('contact_name').value).to eq 'New VRS Services contact'
  end

  scenario 'without any required fields' do
    click_button 'Create contact'
    expect(page).to have_content "Name can't be blank for Contact"
  end

  scenario 'with email' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    fill_in 'contact_email', with: 'foo@bar.com'
    click_button 'Create contact'
    click_link 'New VRS Services contact'

    expect(find_field('contact_email').value).to eq 'foo@bar.com'
  end

  scenario 'with department' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    fill_in 'contact_department', with: 'new department'
    click_button 'Create contact'
    click_link 'New VRS Services contact'

    expect(find_field('contact_department').value).to eq 'new department'
  end

  scenario 'with title' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    fill_in 'contact_title', with: 'CTO'
    click_button 'Create contact'
    click_link 'New VRS Services contact'

    expect(find_field('contact_title').value).to eq 'CTO'
  end

  # Contacts use the same form for adding phone numbers as Locations,
  # and the form is already tested there. We just need to make sure
  # that the form is present for Contacts.
  scenario 'with phone' do
    expect(page).to have_link 'Add a new phone'
  end
end

describe 'when admin does not have access to the service' do
  it 'denies access to create a new contact' do
    create_service
    login_admin

    visit("/admin/locations/vrs-services/services/#{@service.id}/contacts/new")

    expect(page).to have_content I18n.t('admin.not_authorized')
  end
end
