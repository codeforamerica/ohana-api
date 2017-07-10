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
      address_1: '123',
      city: 'Vienna',
      state_province: 'VA',
      postal_code: '12345'
    )
    visit '/admin/locations/vrs-services'

    expect(find_field('location_mail_address_attributes_attention').value).
      to eq 'moncef'
    expect(find_field('location_mail_address_attributes_address_1').value).
      to eq '123'
    expect(find_field('location_mail_address_attributes_city').value).
      to eq 'Vienna'
    expect(find_field('location_mail_address_attributes_state_province').value).
      to eq 'VA'
    expect(find_field('location_mail_address_attributes_postal_code').value).
      to eq '12345'

    expect(@location.reload.mail_address.country).to eq 'US'

    remove_mail_address
    visit '/admin/locations/vrs-services'
    expect(page).to have_link I18n.t('admin.buttons.add_mailing_address')
  end

  scenario 'when leaving location without address or mail address', :js do
    remove_street_address
    expect(page).
      to have_content 'Street Address must be provided unless a Location is virtual'
  end
end

feature 'Updating mailing address with invalid values' do
  before(:all) do
    @location = create(:mail_address).location
  end

  before(:each) do
    login_super_admin
    visit '/admin/locations/no-address'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  scenario 'with an empty street' do
    update_mailing_address(address_1: '', city: 'fair', state_province: 'VA',
                           postal_code: '12345')
    click_button I18n.t('admin.buttons.save_changes')

    expect(page).to have_content "Street (Line 1) can't be blank for Mail Address"
  end

  scenario 'with an empty city' do
    update_mailing_address(address_1: '123', city: '', state_province: 'VA',
                           postal_code: '12345')
    click_button I18n.t('admin.buttons.save_changes')

    expect(page).to have_content "City can't be blank for Mail Address"
  end

  scenario 'with an empty state' do
    update_mailing_address(address_1: '123', city: 'fair', state_province: '',
                           postal_code: '12345')
    click_button I18n.t('admin.buttons.save_changes')

    expect(page).to have_content t('errors.messages.invalid_state_province')
  end

  scenario 'with an empty zip' do
    update_mailing_address(address_1: '123', city: 'Belmont', state_province: 'CA',
                           postal_code: '')
    click_button I18n.t('admin.buttons.save_changes')

    expect(page).to have_content "ZIP Code can't be blank for Mail Address"
  end

  scenario 'with an invalid state' do
    update_mailing_address(address_1: '123', city: 'Par', state_province: 'V',
                           postal_code: '12345')
    click_button I18n.t('admin.buttons.save_changes')

    expect(page).to have_content t('errors.messages.invalid_state_province')
  end

  scenario 'with an invalid zip' do
    update_mailing_address(address_1: '123', city: 'Ald', state_province: 'VA',
                           postal_code: '1234')
    click_button I18n.t('admin.buttons.save_changes')

    expect(page).to have_content 'valid ZIP code'
  end
end
