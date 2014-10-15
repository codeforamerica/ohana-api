require 'rails_helper'

feature 'Organizations page' do
  context 'when not signed in' do
    before :each do
      visit '/admin/organizations'
    end

    it 'redirects to the admin sign in page' do
      expect(current_path).to eq(new_admin_session_path)
    end

    it 'prompts the user to sign in or sign up' do
      expect(page).
        to have_content 'You need to sign in or sign up before continuing.'
    end

    it 'does not include a link to organizations in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Organizations', href: admin_organizations_path
      end
    end
  end

  context 'when signed in' do
    before :each do
      login_admin
      visit '/admin/organizations'
    end

    it 'displays instructions for editing organizations' do
      expect(page).to have_content 'Below you should see a list of organizations'
      expect(page).to have_content 'To start updating, click on one of the links'
      expect(page).not_to have_content 'As a super admin'
    end

    it 'only shows links that belong to the admin' do
      create(:nearby_loc)
      create(:location_for_org_admin)
      visit '/admin/organizations'
      expect(page).not_to have_link 'Food Stamps'
      expect(page).to have_link 'Far Org'
    end
  end

  context 'when signed in as super admin' do
    before :each do
      login_super_admin
      visit '/admin/organizations'
    end

    it 'displays instructions for editing organizations' do
      expect(page).to have_content 'As a super admin'
    end

    it 'shows all organizations' do
      create(:nearby_loc)
      create(:location_for_org_admin)
      visit '/admin/organizations'
      expect(page).to have_link 'Food Stamps'
      expect(page).to have_link 'Far Org'
    end
  end
end
