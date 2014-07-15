require 'rails_helper'

feature "Updating a location's address" do
  before(:each) do
    @location = create(:no_address)
    login_super_admin
    visit '/admin/locations/no-address'
  end

  scenario 'adding a new street address with valid values', :js do
    add_street_address(street: '123', city: 'Vienn', state: 'VA', zip: '12345')
    visit '/admin/locations/no-address'

    expect(find_field('location_address_attributes_street').value).to eq '123'
    expect(find_field('location_address_attributes_city').value).to eq 'Vienn'
    expect(find_field('location_address_attributes_state').value).to eq 'VA'
    expect(find_field('location_address_attributes_zip').value).to eq '12345'

    remove_street_address
    visit '/admin/locations/no-address'
    expect(page).to have_link 'Add a street address'
  end

  scenario 'when leaving location without address or mail address', :js do
    remove_mail_address
    expect(page).
      to have_content 'A location must have at least one address type'
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
    update_street_address(street: '', city: 'fair', state: 'VA', zip: '12345')
    click_button 'Save changes'
    expect(page).to have_content "street can't be blank for Address"
  end

  scenario 'with an empty city' do
    update_street_address(street: '123', city: '', state: 'VA', zip: '12345')
    click_button 'Save changes'
    expect(page).to have_content "city can't be blank for Address"
  end

  scenario 'with an empty state' do
    update_street_address(street: '123', city: 'fair', state: '', zip: '12345')
    click_button 'Save changes'
    expect(page).to have_content "state can't be blank for Address"
  end

  scenario 'with an empty zip' do
    update_street_address(street: '123', city: 'Belmont', state: 'CA', zip: '')
    click_button 'Save changes'
    expect(page).to have_content "zip can't be blank for Address"
  end

  scenario 'with an invalid state' do
    update_street_address(street: '123', city: 'Par', state: 'V', zip: '12345')
    click_button 'Save changes'
    expect(page).to have_content 'valid 2-letter state abbreviation'
  end

  scenario 'with an invalid zip' do
    update_street_address(street: '123', city: 'Ald', state: 'VA', zip: '1234')
    click_button 'Save changes'
    expect(page).to have_content 'valid ZIP code'
  end
end
