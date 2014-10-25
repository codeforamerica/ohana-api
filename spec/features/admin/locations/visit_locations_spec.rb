require 'rails_helper'

feature 'Locations page' do
  context 'when not signed in' do
    before :each do
      visit '/admin/locations'
    end

    it 'redirects to the admin sign in page' do
      expect(current_path).to eq(new_admin_session_path)
    end

    it 'prompts the user to sign in or sign up' do
      expect(page).
        to have_content 'You need to sign in or sign up before continuing.'
    end

    it 'does not include a link to the Home page in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Home', href: root_path
      end
    end

    it 'does not include a link to Your locations in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Your locations', href: admin_locations_path
      end
    end
  end

  context 'when signed in' do
    before :each do
      login_admin
      visit '/admin/locations'
    end

    it 'displays instructions for editing locations' do
      expect(page).to have_content 'Below you should see a list of locations'
      expect(page).to have_content 'To start updating, click on one of the links'
    end

    it 'only shows links that belong to the admin' do
      create(:location)
      create(:location_for_org_admin)
      visit '/admin/locations'
      expect(page).not_to have_link 'VRS Services'
      expect(page).to have_link 'Samaritan House'
    end

    it 'does not include a link to the sign up page in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Sign up'
      end
    end

    it 'does not include a link to the sign in page in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Sign in'
      end
    end

    it 'includes a link to sign out in the navigation' do
      within '.navbar' do
        expect(page).
          to have_link 'Sign out', href: destroy_admin_session_path
      end
    end

    it 'includes a link to the Edit Account page in the navigation' do
      within '.navbar' do
        expect(page).
          to have_link 'Edit account', href: edit_admin_registration_path
      end
    end

    it 'displays the name of the logged in admin in the navigation' do
      within '.navbar' do
        expect(page).to have_content "Hi, #{@admin.name}"
      end
    end

    it 'includes a link to locations in the navigation' do
      within '.navbar' do
        expect(page).to have_link 'Locations', href: admin_locations_path
      end
    end
  end

  context 'when signed in as super admin' do
    before :each do
      @location = create(:location)
      create(:location_for_org_admin)
      login_super_admin
      visit '/admin/locations'
    end

    it 'displays instructions for editing locations' do
      expect(page).to have_content 'As a super admin'
    end

    it 'shows all locations' do
      expect(page).to have_link 'VRS Services'
      expect(page).to have_link 'Samaritan House'
      expect(page).not_to have_content 'Parent Agency locations'
    end

    it 'takes you to the right location when clicked' do
      click_link 'VRS Services'
      expect(current_path).to eq edit_admin_location_path(@location)
    end
  end
end
