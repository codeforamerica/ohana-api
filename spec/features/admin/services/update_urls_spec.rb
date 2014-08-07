require 'rails_helper'

feature 'Update websites' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'when no websites exist' do
    expect(page).to have_no_xpath("//input[@name='service[urls][]']")
  end

  scenario 'by adding 2 new websites', :js do
    add_two_urls
    expect(find_field('service_urls_0').value).to eq 'http://ruby.com'
    delete_all_urls
    expect(page).to have_no_xpath("//input[@name='service[urls][]']")
  end

  scenario 'with 2 urls but one is empty', :js do
    @service.update!(urls: ['http://ruby.org'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    click_link 'Add a website'
    click_button 'Save changes'
    total_urls = all(:xpath, "//input[@type='url']")
    expect(total_urls.length).to eq 1
  end

  scenario 'with invalid website' do
    @service.update!(urls: ['http://ruby.org'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    fill_in 'service_urls_0', with: 'www.monfresh.com'
    click_button 'Save changes'
    expect(page).to have_content 'www.monfresh.com is not a valid URL'
  end

  scenario 'with valid website' do
    @service.update!(urls: ['http://ruby.org'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    fill_in 'service_urls_0', with: 'http://codeforamerica.org'
    click_button 'Save changes'
    expect(find_field('service_urls_0').value).
      to eq 'http://codeforamerica.org'
  end
end
