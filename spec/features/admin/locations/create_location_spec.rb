require 'rails_helper'

feature 'Create a new location' do
  background do
    create(:organization)
    login_super_admin
    visit('/admin/locations/new')
  end

  scenario 'with all required fields', :js do
    fill_in_all_required_fields
    click_button 'Create location'
    expect(current_path).to eq admin_locations_path
    click_link 'New Parent Agency location'

    expect(find_field('location_name').value).to eq 'New Parent Agency location'
    expect(find_field('location_description').value).to eq 'new description'
    expect(find_field('location_address_attributes_street_1').value).
      to eq '123 Main St.'
    expect(find_field('location_address_attributes_city').value).
      to eq 'Belmont'
    expect(find_field('location_address_attributes_state').value).to eq 'CA'
    expect(find_field('location_address_attributes_postal_code').value).to eq '12345'
  end

  scenario 'without any required fields' do
    click_button 'Create location'
    expect(page).to have_content "Unless it's virtual, a location must have an address."
    expect(page).to have_content "Description can't be blank for Location"
    expect(page).to have_content "Name can't be blank for Location"
    expect(page).to have_content "Organization can't be blank for Location"
  end

  scenario 'with valid mailing address', :js do
    fill_in_all_required_fields
    click_link 'Add a mailing address'
    update_mailing_address(
      attention: 'moncef',
      street_1: '123',
      city: 'Vienna',
      state: 'VA',
      postal_code: '12345',
      country_code: 'US'
    )
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_mail_address_attributes_attention').value).
      to eq 'moncef'
    expect(find_field('location_mail_address_attributes_street_1').value).
      to eq '123'
    expect(find_field('location_mail_address_attributes_city').value).
      to eq 'Vienna'
    expect(find_field('location_mail_address_attributes_state').value).
      to eq 'VA'
    expect(find_field('location_mail_address_attributes_postal_code').value).
      to eq '12345'
  end

  scenario 'with valid phone number', :js do
    fill_in_all_required_fields
    add_phone(
      number: '123-456-7890',
      number_type: 'TTY',
      department: 'Director of Development',
      extension: '1234',
      vanity_number: '123-ABC-DEFG'
    )
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_phones_attributes_0_number').value).
      to eq '123-456-7890'

    expect(find_field('location_phones_attributes_0_number_type').value).
      to eq 'tty'

    expect(find_field('location_phones_attributes_0_department').value).
      to eq 'Director of Development'

    expect(find_field('location_phones_attributes_0_extension').value).
      to eq '1234'

    expect(find_field('location_phones_attributes_0_vanity_number').value).
      to eq '123-ABC-DEFG'
  end

  scenario 'with valid location email', :js do
    fill_in_all_required_fields
    click_link 'Add a new general email'
    fill_in 'location[emails][]', with: 'moncefbelyamani@samaritanhousesanmateo.org'

    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location[emails][]').value).
      to eq 'moncefbelyamani@samaritanhousesanmateo.org'
  end

  scenario 'with valid location hours', :js do
    fill_in_all_required_fields
    fill_in 'location_hours', with: 'Monday-Friday 10am-5pm'
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_hours').value).to eq 'Monday-Friday 10am-5pm'
  end

  scenario 'when adding an accessibility option', :js do
    fill_in_all_required_fields
    check 'location_accessibility_elevator'
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find('#location_accessibility_elevator')).to be_checked
  end

  scenario 'when adding transportation option', :js do
    fill_in_all_required_fields
    fill_in 'location_transportation', with: 'SAMTRANS stops within 1/2 mile.'
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_transportation').value).
      to eq 'SAMTRANS stops within 1/2 mile.'
  end

  scenario 'when adding a website', :js do
    fill_in_all_required_fields
    click_link 'Add a new website'
    fill_in find(:xpath, "//input[@type='url']")[:id], with: 'http://ruby.com'
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location[urls][]').value).to eq 'http://ruby.com'
  end

  scenario 'when adding an alternate name', :js do
    fill_in_all_required_fields
    fill_in 'location_alternate_name', with: 'HSA'
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_alternate_name').value).
      to eq 'HSA'
  end

  scenario 'when setting the virtual attribute', :js do
    select2('Parent Agency', 'org-name')
    fill_in 'location_name', with: 'New Parent Agency location'
    fill_in 'location_description', with: 'new description'
    select('Does not have a physical address', from: 'location_virtual')
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_virtual').value).
      to eq 'true'
  end
end

describe 'creating a new location as regular admin' do
  it 'prepopulates the current user as an admin for the new location' do
    create(:location_for_org_admin)
    login_admin

    visit('/admin/locations/new')

    expect(find_field('location[admin_emails][]').value).
      to eq 'moncef@samaritanhouse.com'
  end
end
