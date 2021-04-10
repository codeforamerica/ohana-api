require 'rails_helper'

describe 'Update description' do
  before do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  it 'with empty organization description' do
    fill_in 'organization_description', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Description can't be blank for Organization"
  end

  it 'with valid organization description' do
    fill_in 'organization_description', with: 'Juvenile Sexual Responsibility Program'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_description').value).
      to eq 'Juvenile Sexual Responsibility Program'
  end
end
