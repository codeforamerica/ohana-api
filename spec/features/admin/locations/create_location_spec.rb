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
    fill_in 'location_email', with: 'moncefbelyamani@samaritanhousesanmateo.org'

    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_email').value).
      to eq 'moncefbelyamani@samaritanhousesanmateo.org'
  end

  scenario 'with valid location hours', :js do
    fill_in_all_required_fields
    add_hour(
      weekday: 'Tuesday',
      opens_at_hour: '9 AM', opens_at_minute: '30',
      closes_at_hour: '5 PM', closes_at_minute: '45'
    )
    click_button 'Create location'
    click_link 'New Parent Agency location'

    prefix = 'location_regular_schedules_attributes_0'

    expect(find_field("#{prefix}_weekday").value).to eq '2'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq '09'
    expect(find_field("#{prefix}_opens_at_5i").value).to eq '30'

    expect(find_field("#{prefix}_closes_at_4i").value).to eq '17'
    expect(find_field("#{prefix}_closes_at_5i").value).to eq '45'
  end

  scenario 'with valid holiday schedule', :js do
    fill_in_all_required_fields
    add_holiday_schedule(
      start_month: 'January',
      start_day: '1',
      end_month: 'January',
      end_day: '2',
      closed: 'Closed'
    )
    click_button 'Create location'
    click_link 'New Parent Agency location'

    prefix = 'location_holiday_schedules_attributes_0'

    expect(find_field("#{prefix}_start_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_start_date_3i").value).to eq '1'

    expect(find_field("#{prefix}_end_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_end_date_3i").value).to eq '2'

    expect(find_field("#{prefix}_closed").value).to eq 'true'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq ''
    expect(find_field("#{prefix}_opens_at_5i").value).to eq ''

    expect(find_field("#{prefix}_closes_at_4i").value).to eq ''
    expect(find_field("#{prefix}_closes_at_5i").value).to eq ''
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
    fill_in 'location_website', with: 'http://ruby.com'
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_website').value).to eq 'http://ruby.com'
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

  scenario 'when setting languages', :js do
    fill_in_all_required_fields
    select2('French', 'location_languages', multiple: true)
    select2('Spanish', 'location_languages', multiple: true)
    click_button 'Create location'
    click_link 'New Parent Agency location'

    expect(find_field('location_languages').value).to eq %w(French Spanish)
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
