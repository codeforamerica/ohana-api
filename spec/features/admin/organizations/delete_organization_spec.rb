require 'rails_helper'

feature 'Delete organization' do
  background do
    create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'when submitting warning', :js do
    find_link(I18n.t('admin.buttons.delete_organization')).click
    find_link(I18n.t('admin.buttons.confirm_delete_organization')).click
    using_wait_time 5 do
      expect(current_path).to eq admin_organizations_path
      expect(page).not_to have_link 'Parent Agency'
    end
  end

  scenario 'when canceling warning', :js do
    find_link(I18n.t('admin.buttons.delete_organization')).click
    find_button('Close').click
    visit admin_organizations_path
    expect(page).to have_link 'Parent Agency'
  end
end
