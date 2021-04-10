require 'rails_helper'

describe 'Update name' do
  before do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  it 'with empty organization name' do
    fill_in 'organization_name', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Name can't be blank for Organization"
  end

  it 'with valid organization name' do
    fill_in 'organization_name', with: 'Juvenile Sexual Responsibility Program'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_name').value).
      to eq 'Juvenile Sexual Responsibility Program'
  end
end
