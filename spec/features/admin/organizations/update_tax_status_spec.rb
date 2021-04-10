require 'rails_helper'

describe 'Update tax status' do
  before do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  it 'with tax status' do
    fill_in 'organization_tax_status', with: '501(c)(3)'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_tax_status').value).to eq '501(c)(3)'
  end
end
