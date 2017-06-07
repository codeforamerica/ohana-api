require 'rails_helper'

feature 'Add a street address' do
  before(:each) do
    @location = create(:no_address)
    login_super_admin
    visit '/admin/locations/no-address'
  end

  scenario 'adding a new street address with valid values', :js do
    add_street_address(address_1: '123', city: 'Vienn', state_province: 'VA',
                       postal_code: '12345', country: 'US')
    visit '/admin/locations/no-address'

    expect(find_field('location_address_attributes_address_1').value).to eq '123'
    expect(find_field('location_address_attributes_city').value).to eq 'Vienn'
    expect(find_field('location_address_attributes_state_province').value).to eq 'VA'
    expect(find_field('location_address_attributes_postal_code').value).to eq '12345'

    remove_street_address
    visit '/admin/locations/no-address'
    expect(page).to have_link I18n.t('admin.buttons.add_street_address')
  end
end

feature "Updating a location's address with invalid values" do
  before(:all) do
    @location = create(:location)
  end

  before(:each) do
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  scenario 'with an empty street' do
    update_street_address(address_1: '', city: 'fair', state_province: 'VA',
                          postal_code: '12345', country: 'US')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Street (Line 1) can't be blank for Address"
  end

  scenario 'with an empty city' do
    update_street_address(address_1: '123', city: '', state_province: 'VA',
                          postal_code: '12345', country: 'US')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "City can't be blank for Address"
  end

  scenario 'with an empty state' do
    update_street_address(address_1: '123', city: 'fair', state_province: '',
                          postal_code: '12345', country: 'US')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content t('errors.messages.invalid_state_province')
  end

  scenario 'with an empty zip' do
    update_street_address(address_1: '123', city: 'Belmont', state_province: 'CA',
                          postal_code: '')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "ZIP Code can't be blank for Address"
  end

  scenario 'with an empty country' do
    update_street_address(address_1: '123', city: 'Belmont', state_province: 'CA',
                          postal_code: '12345')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Country Code can't be blank for Address"
  end

  scenario 'with an invalid state' do
    update_street_address(address_1: '123', city: 'Par', state_province: 'V',
                          postal_code: '12345', country: 'US')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content t('errors.messages.invalid_state_province')
  end

  scenario 'with an invalid zip' do
    update_street_address(address_1: '123', city: 'Ald', state_province: 'VA',
                          postal_code: '1234', country: 'US')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'valid ZIP code'
  end

  scenario 'with an invalid country' do
    update_street_address(address_1: '123', city: 'Ald', state_province: 'VA',
                          postal_code: '12345', country: 'U')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'too short'
  end
end

feature 'Remove a street address' do
  before(:each) do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'from a non-virtual location', :js do
    remove_street_address
    expect(page).
      to have_content 'Street Address must be provided unless a Location is virtual'
  end
end
