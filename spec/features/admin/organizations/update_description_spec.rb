require 'rails_helper'

feature 'Update description' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with empty organization description' do
    fill_in 'organization_description', with: ''
    click_button 'Save changes'
    expect(page).to have_content "Description can't be blank for Organization"
  end

  scenario 'with valid organization description' do
    fill_in 'organization_description', with: 'Juvenile Sexual Responsibility Program'
    click_button 'Save changes'
    expect(find_field('organization_description').value).
      to eq 'Juvenile Sexual Responsibility Program'
  end
end
