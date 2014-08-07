require 'rails_helper'

feature 'Update keywords' do
  background do
    create_service
    login_super_admin
  end

  scenario 'when no keywords exist' do
    @service.update!(keywords: [])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    expect(page).to have_no_xpath("//input[@name='service[keywords][]']")
  end

  scenario 'by adding 2 new keywords', :js do
    @service.update!(keywords: [])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    add_two_keywords
    expect(find_field('service_keywords_0').value).to eq 'homeless'
    delete_all_keywords
    expect(page).to have_no_xpath("//input[@name='service[keywords][]']")
  end

  scenario 'with 2 keywords but one is empty', :js do
    @service.update!(keywords: ['education'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    click_link 'Add a keyword'
    click_button 'Save changes'
    total_keywords = all(:xpath, "//input[@name='service[keywords][]']")
    expect(total_keywords.length).to eq 1
  end

  scenario 'with valid keyword' do
    @service.update!(keywords: ['health'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    fill_in 'service_keywords_0', with: 'food pantry'
    click_button 'Save changes'
    expect(find_field('service_keywords_0').value).
      to eq 'food pantry'
  end
end
