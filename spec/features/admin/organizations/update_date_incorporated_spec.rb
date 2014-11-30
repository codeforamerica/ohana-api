require 'rails_helper'

feature 'Update date incorporated' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with date incorporated' do
    select_date(Date.today, from: 'organization_date_incorporated')
    click_button 'Save changes'

    expect(find_field('organization_date_incorporated_1i').value).
      to eq Date.today.year.to_s
    expect(find_field('organization_date_incorporated_2i').value).
      to eq Date.today.month.to_s
    expect(find_field('organization_date_incorporated_3i').value).
      to eq Date.today.day.to_s
  end
end
