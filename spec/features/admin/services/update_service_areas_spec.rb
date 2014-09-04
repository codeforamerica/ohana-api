require 'rails_helper'

feature 'Update service areas' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'when no service areas exist' do
    expect(page).to have_no_xpath("//input[@name='service[service_areas][]']")
  end

  scenario 'by adding 2 new service areas', :js do
    add_two_service_areas
    expect(find_field('service_service_areas_0').value).to eq 'Belmont'
    delete_all_service_areas
    expect(page).to have_no_xpath("//input[@name='service[service_areas][]']")
  end

  scenario 'with 2 service_areas but one is empty', :js do
    @service.update!(service_areas: ['Belmont'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    click_link 'Add a new service area'
    click_button 'Save changes'
    total_service_areas = all(:xpath, "//input[@name='service[service_areas][]']")
    expect(total_service_areas.length).to eq 1
  end

  scenario 'with 2 service_areas but only one is invalid', :js do
    @service.update!(service_areas: ['Belmont'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    click_link 'Add a new service area'
    service_areas = page.
        all(:xpath, "//input[@name='service[service_areas][]']")
    fill_in service_areas[-1][:id], with: 'Alexandria'
    click_button 'Save changes'
    total_fields_with_errors = page.all(:css, '.field_with_errors')
    expect(total_fields_with_errors.length).to eq 1
  end

  scenario 'with invalid service area' do
    @service.update!(service_areas: ['Belmont'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    fill_in 'service_service_areas_0', with: 'Fairfax'
    click_button 'Save changes'
    expect(page).
      to have_content 'Fairfax is not a valid service area'
    expect(page).to have_css('.field_with_errors')
  end

  scenario 'with valid service area' do
    @service.update!(service_areas: ['Belmont'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    fill_in 'service_service_areas_0', with: 'Atherton'
    click_button 'Save changes'
    expect(find_field('service_service_areas_0').value).
      to eq 'Atherton'
  end

  scenario 'clearing out existing service area' do
    @service.update!(service_areas: ['Belmont'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    fill_in 'service_service_areas_0', with: ''
    click_button 'Save changes'
    expect(page).not_to have_field('service_service_areas_0')
  end
end
