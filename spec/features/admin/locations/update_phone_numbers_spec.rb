require 'rails_helper'

feature 'Update phones' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'when no phones exist' do
    within('.phones') do
      expect(page).
        to have_no_xpath('.//input[contains(@name, "[extension]")]')
    end

    expect(page).to_not have_link 'Delete this phone permanently'
  end

  scenario 'by adding a new phone', :js do
    add_phone(
      number: '123-456-7890',
      number_type: 'TTY',
      department: 'Director of Development',
      extension: 'x1234',
      vanity_number: '123-ABC-DEFG'
    )
    click_button 'Save changes'
    visit '/admin/locations/vrs-services'

    expect(find_field('location_phones_attributes_0_number').value).
      to eq '123-456-7890'

    expect(find_field('location_phones_attributes_0_number_type').value).
      to eq 'TTY'

    expect(find_field('location_phones_attributes_0_department').value).
      to eq 'Director of Development'

    expect(find_field('location_phones_attributes_0_extension').value).
      to eq 'x1234'

    expect(find_field('location_phones_attributes_0_vanity_number').value).
      to eq '123-ABC-DEFG'

    delete_phone
    visit '/admin/locations/vrs-services'
    within('.phones') do
      expect(page).
        to have_no_xpath('.//input[contains(@name, "[vanity_number]")]')
    end
  end

  scenario 'with 2 phones but one is empty', :js do
    add_phone(
      number: '123-456-7890',
      department: 'Director of Development'
    )
    click_link 'Add a new phone number'
    click_button 'Save changes'

    within('.phones') do
      total_phones = all(:xpath, './/input[contains(@name, "[number]")]')
      expect(total_phones.length).to eq 1
    end
  end

  scenario 'with 2 phones but second one is invalid', :js do
    add_phone(
      number: '123-456-7890',
      department: 'Director of Development'
    )
    click_link 'Add a new phone number'
    within('.phones') do
      all_phones = all(:xpath, './/input[contains(@name, "[department]")]')
      fill_in all_phones[-1][:id], with: 'Department'
    end
    click_button 'Save changes'
    expect(page).to have_content "number can't be blank for Phone"
  end

  scenario 'delete second phone', :js do
    # There was a bug where clicking the "Delete this phone permanently"
    # button would hide all phones from the form, and would set the id
    # of the first phone to "1", causing an error when submitting the form.
    # To test this, we need to make sure neither of the phones we are trying
    # to delete have an id of 1, so we need to create 3 phones first and
    # test with the last 2.
    @location.phones.create!(number: '124-456-7890', department: 'Ruby')
    new_loc = create(:nearby_loc)
    new_loc.phones.create!(number: '123-456-7890', department: 'Python')
    new_loc.phones.create!(number: '456-123-7890', department: 'JS')

    visit '/admin/locations/library'

    find(:xpath, "(//a[text()='Delete this phone permanently'])[2]").click
    click_button 'Save changes'

    expect(find_field('location_phones_attributes_0_number').value).
      to eq '123-456-7890'

    expect(page).
      to have_no_xpath('//input[@id="location_phones_attributes_1_number"]')
  end
end

feature 'Update phones' do
  before(:all) do
    @location = create(:location)
    @location.phones.create!(number: '123-456-7890', department: 'Ruby')
  end

  before(:each) do
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  scenario 'with an empty number' do
    update_phone(number: '')
    click_button 'Save changes'
    expect(page).to have_content "number can't be blank for Phone"
  end

  scenario 'with an invalid number' do
    update_phone(number: '703')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid US phone number'
  end
end
