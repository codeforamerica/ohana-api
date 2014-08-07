require 'rails_helper'

feature 'Update name' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with empty organization name' do
    fill_in 'organization_name', with: ''
    click_button 'Save changes'
    expect(page).to have_content "Name can't be blank for Organization"
  end

  scenario 'with valid organization name' do
    fill_in 'organization_name', with: 'Juvenile Sexual Responsibility Program'
    click_button 'Save changes'
    expect(find_field('organization_name').value).
      to eq 'Juvenile Sexual Responsibility Program'
  end
end
