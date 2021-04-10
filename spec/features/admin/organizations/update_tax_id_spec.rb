require 'rails_helper'

describe 'Update tax id' do
  before do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  it 'with tax id' do
    fill_in 'organization_tax_id', with: '12-1234567'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_tax_id').value).to eq '12-1234567'
  end
end
