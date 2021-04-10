require 'rails_helper'

describe 'Update email' do
  before do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  it 'with valid organization email' do
    fill_in 'organization_email', with: 'foo@bar.com'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_email').value).to eq 'foo@bar.com'
  end

  it 'with invalid organization email' do
    fill_in 'organization_email', with: 'foobar.com'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'foobar.com is not a valid email'
  end
end
