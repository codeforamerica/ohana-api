require 'rails_helper'

feature 'Updating mailing address' do
  before(:each) do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'adding a new mailing address with valid values', :js do
    add_mailing_address(
      attention: 'moncef',
      street_1: '123',
      city: 'Vienna',
      state: 'VA',
      postal_code: '12345',
      country_code: 'US'
    )
    visit '/admin/locations/vrs-services'

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

    remove_mail_address
    visit '/admin/locations/vrs-services'
    expect(page).to have_link 'Add a mailing address'
  end

  scenario 'when leaving location without address or mail address', :js do
    remove_street_address
    expect(page).
      to have_content "Unless it's virtual, a location must have an address."
  end
end

feature 'Updating mailing address with invalid values' do
  before(:all) do
    @location = create(:no_address)
  end

  before(:each) do
    login_super_admin
    visit '/admin/locations/no-address'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  scenario 'with an empty street' do
    update_mailing_address(street_1: '', city: 'fair', state: 'VA',
                           postal_code: '12345', country_code: 'US')
    click_button 'Save changes'
    expect(page).to have_content "street 1 can't be blank for Mail Address"
  end

  scenario 'with an empty city' do
    update_mailing_address(street_1: '123', city: '', state: 'VA',
                           postal_code: '12345', country_code: 'US')
    click_button 'Save changes'
    expect(page).to have_content "city can't be blank for Mail Address"
  end

  scenario 'with an empty state' do
    update_mailing_address(street_1: '123', city: 'fair', state: '',
                           postal_code: '12345', country_code: 'US')
    click_button 'Save changes'
    expect(page).to have_content "state can't be blank for Mail Address"
  end

  scenario 'with an empty zip' do
    update_mailing_address(street_1: '123', city: 'Belmont', state: 'CA',
                           postal_code: '', country_code: 'US')
    click_button 'Save changes'
    expect(page).to have_content "postal code can't be blank for Mail Address"
  end

  scenario 'with an empty country_code' do
    update_mailing_address(street_1: '123', city: 'Belmont', state: 'CA',
                           postal_code: '12345')
    click_button 'Save changes'
    expect(page).to have_content "country code can't be blank for Mail Address"
  end

  scenario 'with an invalid state' do
    update_mailing_address(street_1: '123', city: 'Par', state: 'V',
                           postal_code: '12345', country_code: 'US')
    click_button 'Save changes'
    expect(page).to have_content 'too short'
  end

  scenario 'with an invalid zip' do
    update_mailing_address(street_1: '123', city: 'Ald', state: 'VA',
                           postal_code: '1234', country_code: 'US')
    click_button 'Save changes'
    expect(page).to have_content 'valid ZIP code'
  end

  scenario 'with an invalid country_code' do
    update_mailing_address(street_1: '123', city: 'Ald', state: 'VA',
                           postal_code: '12345', country_code: 'U')
    click_button 'Save changes'
    expect(page).to have_content 'too short'
  end
end
