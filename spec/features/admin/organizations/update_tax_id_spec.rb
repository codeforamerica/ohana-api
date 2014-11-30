require 'rails_helper'

feature 'Update tax id' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with tax id' do
    fill_in 'organization_tax_id', with: '12-1234567'
    click_button 'Save changes'
    expect(find_field('organization_tax_id').value).to eq '12-1234567'
  end
end
