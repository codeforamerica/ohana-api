require 'rails_helper'

describe 'Editing Admin account' do
  before do
    login_admin
    visit '/admin/edit'
  end

  it 'allows the name to be changed' do
    fill_in 'admin_name', with: 'New Admin name'
    fill_in 'admin_current_password', with: @admin.password
    click_button I18n.t('buttons.update')
    visit '/admin/edit'
    expect(find_field('admin_name').value).to eq 'New Admin name'
  end

  it 'redirects to the admin edit page after update' do
    fill_in 'admin_name', with: 'New Admin name'
    fill_in 'admin_current_password', with: @admin.password
    click_button I18n.t('buttons.update')
    expect(page).to have_current_path edit_admin_registration_path, ignore_query: true
  end
end
