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
    expect(page).to have_link 'Add a street address'
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
    click_button 'Save changes'
    expect(page).to have_content "address 1 can't be blank for Address"
  end

  scenario 'with an empty city' do
    update_street_address(address_1: '123', city: '', state_province: 'VA',
                          postal_code: '12345', country: 'US')
    click_button 'Save changes'
    expect(page).to have_content "city can't be blank for Address"
  end

  scenario 'with an empty state' do
    update_street_address(address_1: '123', city: 'fair', state_province: '',
                          postal_code: '12345', country: 'US')
    click_button 'Save changes'
    expect(page).to have_content "State can't be blank for Address"
  end

  scenario 'with an empty zip' do
    update_street_address(address_1: '123', city: 'Belmont', state_province: 'CA',
                          postal_code: '')
    click_button 'Save changes'
    expect(page).to have_content "postal code can't be blank for Address"
  end

  scenario 'with an empty country' do
    update_street_address(address_1: '123', city: 'Belmont', state_province: 'CA',
                          postal_code: '12345')
    click_button 'Save changes'
    expect(page).to have_content "country can't be blank for Address"
  end

  scenario 'with an invalid state' do
    update_street_address(address_1: '123', city: 'Par', state_province: 'V',
                          postal_code: '12345', country: 'US')
    click_button 'Save changes'
    expect(page).to have_content 'too short'
  end

  scenario 'with an invalid zip' do
    update_street_address(address_1: '123', city: 'Ald', state_province: 'VA',
                          postal_code: '1234', country: 'US')
    click_button 'Save changes'
    expect(page).to have_content 'valid ZIP code'
  end

  scenario 'with an invalid country' do
    update_street_address(address_1: '123', city: 'Ald', state_province: 'VA',
                          postal_code: '12345', country: 'U')
    click_button 'Save changes'
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
      to have_content "Unless it's virtual, a location must have an address."
  end
end
