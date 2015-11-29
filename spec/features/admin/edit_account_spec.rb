require 'rails_helper'

feature 'Editing Admin account' do
  before :each do
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
    expect(current_path).to eq edit_admin_registration_path
  end
end
