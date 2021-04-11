require 'rails_helper'

describe 'Create a new contact for service' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    click_link I18n.t('admin.buttons.add_contact')
  end

  it 'creates a contact for the right service' do
    expect(page).to have_content "Creating contact for #{@service.name}"
  end

  it 'with all required fields' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    click_button I18n.t('admin.buttons.create_contact')
    click_link 'New VRS Services contact'

    expect(find_field('contact_name').value).to eq 'New VRS Services contact'
  end

  it 'without any required fields' do
    click_button I18n.t('admin.buttons.create_contact')
    expect(page).to have_content "Name can't be blank for Contact"
  end

  it 'with email' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    fill_in 'contact_email', with: 'foo@bar.com'
    click_button I18n.t('admin.buttons.create_contact')
    click_link 'New VRS Services contact'

    expect(find_field('contact_email').value).to eq 'foo@bar.com'
  end

  it 'with department' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    fill_in 'contact_department', with: 'new department'
    click_button I18n.t('admin.buttons.create_contact')
    click_link 'New VRS Services contact'

    expect(find_field('contact_department').value).to eq 'new department'
  end

  it 'with title' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    fill_in 'contact_title', with: 'CTO'
    click_button I18n.t('admin.buttons.create_contact')
    click_link 'New VRS Services contact'

    expect(find_field('contact_title').value).to eq 'CTO'
  end

  # Contacts use the same form for adding phone numbers as Locations,
  # and the form is already tested there. We just need to make sure
  # that the form is present for Contacts.
  it 'with phone' do
    expect(page).to have_link I18n.t('admin.buttons.add_phone')
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
