require 'rails_helper'

feature 'Create a new service' do
  background do
    create(:location)
    login_super_admin
    visit('/admin/locations/vrs-services')
    click_link 'Add a new service'
  end

  scenario 'with all required fields' do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_name').value).to eq 'New VRS Services service'
    expect(find_field('service_description').value).to eq 'new description'
  end

  scenario 'without any required fields' do
    click_button 'Create service'
    expect(page).to have_content "Description can't be blank for Service"
    expect(page).to have_content "Name can't be blank for Service"
  end

  scenario 'with audience' do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    fill_in 'service_audience', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_audience').value).to eq 'Low-income residents.'
  end

  scenario 'with eligibility' do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    fill_in 'service_eligibility', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_eligibility').value).to eq 'Low-income residents.'
  end

  scenario 'with fees' do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    fill_in 'service_fees', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_fees').value).to eq 'Low-income residents.'
  end

  scenario 'with how_to_apply' do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    fill_in 'service_how_to_apply', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_how_to_apply').value).to eq 'Low-income residents.'
  end

  scenario 'with wait' do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    fill_in 'service_wait', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_wait').value).to eq 'Low-income residents.'
  end

  scenario 'when adding a website', :js do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    click_link 'Add a new website'
    fill_in find(:xpath, "//input[@type='url']")[:id], with: 'http://ruby.com'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service[urls][]').value).to eq 'http://ruby.com'
  end

  scenario 'when adding a keyword', :js do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    click_link 'Add a new keyword'
    fill_in find(:xpath, "//input[@name='service[keywords][]']")[:id], with: 'ruby'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service[keywords][]').value).to eq 'ruby'
  end

  scenario 'when adding a service area', :js do
    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    select2('Belmont', 'service_service_areas', multiple: true)
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find(:css, 'select#service_service_areas').value).to eq(['Belmont'])
  end

  scenario 'when adding categories', :js do
    emergency = Category.create!(name: 'Emergency', oe_id: '101')
    emergency.children.create!(name: 'Disaster Response', oe_id: '101-01')
    emergency.children.create!(name: 'Subcategory 2', oe_id: '101-02')
    visit('/admin/locations/vrs-services/services/new')

    fill_in 'service_name', with: 'New VRS Services service'
    fill_in 'service_description', with: 'new description'
    check 'category_101'
    check 'category_101-01'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find('#category_101-01')).to be_checked
    expect(find('#category_101')).to be_checked
  end
end

describe 'when admin does not have access to the location' do
  it 'denies access to create a new service' do
    create(:location)
    login_admin

    visit('/admin/locations/vrs-services/services/new')

    expect(page).to have_content "Sorry, you don't have access to that page."
  end
end
