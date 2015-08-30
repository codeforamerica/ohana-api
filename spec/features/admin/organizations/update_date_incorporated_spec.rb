require 'rails_helper'

feature 'Update date incorporated' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with date incorporated' do
    select_date(Time.zone.today, from: 'organization_date_incorporated')
    click_button I18n.t('admin.buttons.save_changes')

    expect(find_field('organization_date_incorporated_1i').value).
      to eq Time.zone.today.year.to_s
    expect(find_field('organization_date_incorporated_2i').value).
      to eq Time.zone.today.month.to_s
    expect(find_field('organization_date_incorporated_3i').value).
      to eq Time.zone.today.day.to_s
  end
end
