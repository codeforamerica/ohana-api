require 'rails_helper'

feature 'Create a new organization' do
  background do
    create(:organization)
    login_super_admin
    visit('/admin/organizations/new')
  end

  scenario 'with all required fields' do
    fill_in 'organization_name', with: 'new org'
    click_button 'Create organization'
    click_link 'new org'

    expect(find_field('organization_name').value).to eq 'new org'
  end

  scenario 'without any required fields' do
    click_button 'Create organization'
    expect(page).to have_content "Name can't be blank for Organization"
  end

  scenario 'when adding a website', :js do
    fill_in 'organization_name', with: 'new org'
    click_link 'Add a website'
    fill_in find(:xpath, "//input[@type='url']")[:id], with: 'http://ruby.com'
    click_button 'Create organization'
    click_link 'new org'

    expect(find_field('organization[urls][]').value).to eq 'http://ruby.com'
  end
end
