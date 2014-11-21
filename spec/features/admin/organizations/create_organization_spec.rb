require 'rails_helper'

feature 'Create a new organization' do
  background do
    create(:organization)
    login_super_admin
    visit('/admin/organizations/new')
  end

  scenario 'with all required fields' do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    click_button 'Create organization'
    click_link 'new org'

    expect(find_field('organization_name').value).to eq 'new org'
    expect(find_field('organization_description').value).to eq 'description for new org'
  end

  scenario 'without any required fields' do
    click_button 'Create organization'
    expect(page).to have_content "Name can't be blank for Organization"
    expect(page).to have_content "Description can't be blank for Organization"
  end

  scenario 'when adding a website' do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    fill_in 'organization_website', with: 'http://ruby.com'
    click_button 'Create organization'
    click_link 'new org'

    expect(find_field('organization_website').value).to eq 'http://ruby.com'
  end
end
