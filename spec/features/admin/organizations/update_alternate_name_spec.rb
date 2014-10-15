require 'rails_helper'

feature 'Update alternate name' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with alternate name' do
    fill_in 'organization_alternate_name', with: 'Juvenile Sexual Responsibility Program'
    click_button 'Save changes'
    expect(find_field('organization_alternate_name').value).
      to eq 'Juvenile Sexual Responsibility Program'
  end
end
