require 'rails_helper'

feature 'Update legal status' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with legal status' do
    fill_in 'organization_legal_status', with: 'non-profit'
    click_button 'Save changes'
    expect(find_field('organization_legal_status').value).to eq 'non-profit'
  end
end
