require 'rails_helper'

feature 'Delete contact' do
  background do
    @org = create(:organization)
    @org.contacts.create!(attributes_for(:contact))
    login_super_admin
    visit '/admin/organizations/parent-agency'
    click_link 'Moncef Belyamani'
  end

  scenario 'when deleting contact' do
    find_link('Permanently delete this contact').click
    using_wait_time 1 do
      expect(current_path).to eq admin_organization_path(@org)
      expect(page).not_to have_link 'Moncef Belyamani'
    end
  end
end
