require 'rails_helper'

feature 'Update faxes' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'when no faxes exist'  do
    within('.faxes') do
      expect(page).
        to have_no_xpath('.//input[contains(@name, "[number]")]')
    end

    expect(page).to_not have_link 'Delete this fax permanently'
  end

  scenario 'by adding a new fax', :js do
    add_fax(
      number: '123-456-7890',
      department: 'Director of Development'
    )
    click_button 'Save changes'
    visit '/admin/locations/vrs-services'

    expect(find_field('location_faxes_attributes_0_number').value).
      to eq '123-456-7890'

    expect(find_field('location_faxes_attributes_0_department').value).
      to eq 'Director of Development'

    delete_fax
    visit '/admin/locations/vrs-services'
    within('.faxes') do
      expect(page).
        to have_no_xpath('.//input[contains(@name, "[department]")]')
    end
  end

  scenario 'with 2 faxes but one is empty', :js do
    add_fax(
      number: '123-456-7890',
      department: 'Director of Development'
    )
    click_link 'Add a fax number'
    click_button 'Save changes'
    visit '/admin/locations/vrs-services'

    within('.faxes') do
      total_faxes = all(:xpath, './/input[contains(@name, "[number]")]')
      expect(total_faxes.length).to eq 1
    end
  end

  scenario 'with 2 faxes but second one is invalid', :js do
    add_fax(
      number: '123-456-7890',
      department: 'Director of Development'
    )
    click_link 'Add a fax'
    within('.faxes') do
      all_faxes = all(:xpath, './/input[contains(@name, "[department]")]')
      fill_in all_faxes[-1][:id], with: 'Department'
    end
    click_button 'Save changes'
    expect(page).to have_content "number can't be blank for Fax"
  end

  scenario 'delete second fax', :js do
    # There was a bug where clicking the "Delete this fax permanently"
    # button would hide all faxes from the form, and would set the id
    # of the first fax to "1", causing an error when submitting the form.
    # To test this, we need to make sure neither of the faxes we are trying
    # to delete have an id of 1, so we need to create 3 faxes first and
    # test with the last 2.
    @location.faxes.create!(number: '124-456-7890', department: 'Ruby')
    new_loc = create(:nearby_loc)
    new_loc.faxes.create!(number: '123-456-7890', department: 'Python')
    new_loc.faxes.create!(number: '456-123-7890', department: 'JS')

    visit '/admin/locations/library'

    find(:xpath, "(//a[text()='Delete this fax permanently'])[2]").click
    click_button 'Save changes'

    expect(find_field('location_faxes_attributes_0_number').value).
      to eq '123-456-7890'

    expect(page).
      to have_no_xpath('//input[@id="location_faxes_attributes_1_number"]')
  end
end

feature 'Update faxes' do
  before(:all) do
    @location = create(:location)
    @location.faxes.create!(number: '123-456-7890', department: 'Ruby')
  end

  before(:each) do
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  scenario 'with an empty number' do
    update_fax(number: '')
    click_button 'Save changes'
    expect(page).to have_content "number can't be blank for Fax"
  end

  scenario 'with an invalid number' do
    update_fax(number: '703')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid US fax number'
  end
end
