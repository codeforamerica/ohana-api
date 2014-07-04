require 'rails_helper'

feature 'Update contacts' do
  background do
    create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'when no contacts exist'  do
    within('#contacts') do
      expect(page).
        to have_no_xpath('.//input[contains(@name, "[name]")]')
    end
  end

  scenario 'by adding a new contact', :js do
    add_contact(
      name: 'Moncef Belyamani-Belyamani',
      title: 'Director of Development and Operations',
      email: 'moncefbelyamani@samaritanhousesanmateo.org',
      phone: '703-555-1212',
      extension: 'x1234',
      fax: '703-555-1234'
    )
    click_button 'Save changes'
    visit '/admin/locations/vrs-services'

    expect(find_field('location_contacts_attributes_0_name').value).
      to eq 'Moncef Belyamani-Belyamani'

    expect(find_field('location_contacts_attributes_0_title').value).
      to eq 'Director of Development and Operations'

    expect(find_field('location_contacts_attributes_0_email').value).
      to eq 'moncefbelyamani@samaritanhousesanmateo.org'

    expect(find_field('location_contacts_attributes_0_phone').value).
      to eq '703-555-1212'

    expect(find_field('location_contacts_attributes_0_extension').value).
      to eq 'x1234'

    expect(find_field('location_contacts_attributes_0_fax').value).to eq '703-555-1234'

    delete_contact
    visit '/admin/locations/vrs-services'
    within('#contacts') do
      expect(page).
        to have_no_xpath('.//input[contains(@name, "[name]")]')
    end
  end

  scenario 'with 2 contacts but one is empty', :js do
    add_contact(
      name: 'Moncef Belyamani-Belyamani',
      title: 'Director of Development and Operations'
    )
    click_link 'Add a contact'
    click_button 'Save changes'
    visit '/admin/locations/vrs-services'

    within('#contacts') do
      total_contacts = all(:xpath, './/input[contains(@name, "[name]")]')
      expect(total_contacts.length).to eq 1
    end
  end

  scenario 'with 2 contacts but second one is invalid', :js do
    add_contact(
      name: 'Moncef Belyamani-Belyamani',
      title: 'Director of Development and Operations'
    )
    click_link 'Add a contact'
    within('#contacts') do
      all_phones = all(:xpath, './/input[contains(@name, "[phone]")]')
      fill_in all_phones[-1][:id], with: '202-555-1212'
    end
    click_button 'Save changes'
    expect(page).to have_content "name can't be blank for Contact"
  end
end

feature 'Update contacts' do
  before(:all) do
    @location = create(:location)
    @location.contacts.create!(name: 'foo', title: 'bar')
  end

  before(:each) do
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  scenario 'with an empty name' do
    update_contact(name: '')
    click_button 'Save changes'
    expect(page).to have_content "name can't be blank for Contact"
  end

  scenario 'with an empty title' do
    update_contact(title: '')
    click_button 'Save changes'
    expect(page).to have_content "title can't be blank for Contact"
  end

  scenario 'with an empty email' do
    update_contact(email: '')
    click_button 'Save changes'
    expect(page).to_not have_content 'is not a valid email'
  end

  scenario 'with an empty phone' do
    update_contact(phone: '')
    click_button 'Save changes'
    expect(page).to_not have_content 'is not a valid US phone number'
  end

  scenario 'with an empty fax' do
    update_contact(fax: '')
    click_button 'Save changes'
    expect(page).to_not have_content 'is not a valid US fax number'
  end

  scenario 'with an invalid email' do
    update_contact(email: '703')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid email'
  end

  scenario 'with an invalid phone' do
    update_contact(phone: '703')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid US phone number'
  end

  scenario 'with an invalid fax' do
    update_contact(fax: '202')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid US fax number'
  end
end
