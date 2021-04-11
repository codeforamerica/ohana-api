require 'rails_helper'

describe 'Create a new contact' do
  before do
    create(:location)
    login_super_admin
    visit('/admin/locations/vrs-services')
    click_link I18n.t('admin.buttons.add_contact')
  end

  it 'with all fields' do
    fill_in 'contact_name', with: 'New VRS Services contact'
    fill_in 'contact_email', with: 'foo@bar.com'
    fill_in 'contact_department', with: 'new department'
    fill_in 'contact_title', with: 'CTO'

    # Contacts use the same form for adding phone numbers as Locations,
    # and the form is already tested there. We just need to make sure
    # that the form is present for Contacts.
    expect(page).to have_link 'Add a new phone'

    click_button I18n.t('admin.buttons.create_contact')
    click_link 'New VRS Services contact'

    expect(find_field('contact_name').value).to eq 'New VRS Services contact'
    expect(find_field('contact_email').value).to eq 'foo@bar.com'
    expect(find_field('contact_department').value).to eq 'new department'
    expect(find_field('contact_title').value).to eq 'CTO'
  end

  it 'without any required fields' do
    click_button I18n.t('admin.buttons.create_contact')
    expect(page).to have_content "Name can't be blank for Contact"
  end
end

describe 'when admin does not have access to the location' do
  it 'denies access to create a new contact' do
    create(:location)
    login_admin

    visit('/admin/locations/vrs-services/contacts/new')

    expect(page).to have_content I18n.t('admin.not_authorized')
  end
end
