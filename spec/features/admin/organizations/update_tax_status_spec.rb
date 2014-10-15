require 'rails_helper'

feature 'Update tax status' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with tax status' do
    fill_in 'organization_tax_status', with: '501(c)(3)'
    click_button 'Save changes'
    expect(find_field('organization_tax_status').value).to eq '501(c)(3)'
  end
end
